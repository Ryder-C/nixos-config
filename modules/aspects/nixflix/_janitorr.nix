{
  config,
  pkgs,
  ...
}: let
  janitorrStatsPort = 8083;

  janitorrStatsApplicationYml = pkgs.writeText "janitorr-stats-application.yml" ''
    jellyfin:
      base-url: "http://localhost:8096"
      api-key: "b44710b742c14881a0b4f3578b2bdb9a"
      poll-interval: "60s"

    quarkus:
      http:
        port: ${toString janitorrStatsPort}
      datasource:
        db-kind: sqlite
        jdbc:
          url: "jdbc:sqlite:/data/janitorr-stats.db"
      log:
        category:
          "com.github.schaka":
            level: INFO
  '';

  applicationYmlTemplate = pkgs.writeText "janitorr-application.yml.template" ''
    logging:
      level:
        com.github.schaka: INFO
      file:
        name: "/logs/janitorr.log"

    file-system:
      access: true
      validate-seeding: true
      leaving-soon-dir: "/storage/media/leaving-soon"
      media-server-leaving-soon-dir: "/storage/media/leaving-soon"
      from-scratch: true
      free-space-check-dir: "/storage"

    application:
      dry-run: true
      run-once: false
      whole-tv-show: false
      whole-show-seeding-check: false
      leaving-soon: 14d
      leaving-soon-threshold-offset-percent: 5
      exclusion-tags:
        - "janitorr_keep"

      media-deletion:
        enabled: true
        movie-expiration:
          5: 15d
          10: 30d
          15: 60d
          20: 90d
        season-expiration:
          5: 15d
          10: 20d
          15: 60d
          20: 120d

      tag-based-deletion:
        enabled: false

      episode-deletion:
        enabled: false

    clients:
      default:
        connect-timeout: 60s
        read-timeout: 60s
        level: NONE

      sonarr:
        enabled: true
        url: "http://localhost:8989"
        api-key: "@SONARR_API_KEY@"
        delete-empty-shows: true
        determine-age-by: MOST_RECENT
        import-exclusions: false
      radarr:
        enabled: true
        url: "http://localhost:7878"
        api-key: "@RADARR_API_KEY@"
        only-delete-files: false
        determine-age-by: most_recent
        import-exclusions: false

      jellyfin:
        enabled: true
        url: "http://localhost:8096"
        api-key: "e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2"
        username: ryder
        password: "@JELLYFIN_PASSWORD@"
        delete: true
        leaving-soon-tv: "Shows (Leaving Soon)"
        leaving-soon-movies: "Movies (Leaving Soon)"
        leaving-soon-type: MOVIES_AND_TV

      jellyseerr:
        enabled: true
        url: "http://localhost:5055"
        api-key: "@SEERR_API_KEY@"
        match-server: false

      janitorr-stats:
        enabled: true
        url: "http://localhost:${toString janitorrStatsPort}"
  '';
in {
  users = {
    groups.janitorr = {};
    groups.janitorr-stats = {};
    users.janitorr = {
      isSystemUser = true;
      group = "janitorr";
      extraGroups = ["media"];
      description = "Janitorr service user";
      home = "/var/lib/janitorr";
    };
    users.janitorr-stats = {
      isSystemUser = true;
      group = "janitorr-stats";
      description = "Janitorr-stats service user";
      home = "/var/lib/janitorr-stats";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/janitorr 0750 janitorr janitorr -"
    "d /var/lib/janitorr/logs 0750 janitorr janitorr -"
    "d /storage/media/leaving-soon 0775 janitorr media -"
    "d /var/lib/janitorr-stats 0750 janitorr-stats janitorr-stats -"
    "d /var/lib/janitorr-stats/data 0750 janitorr-stats janitorr-stats -"
  ];

  systemd.services."${config.virtualisation.oci-containers.backend}-janitorr" = {
    serviceConfig.RuntimeDirectory = "janitorr";
    preStart = ''
      ${pkgs.gnused}/bin/sed \
        -e "s|@SONARR_API_KEY@|$(cat ${config.age.secrets.sonarr.path})|" \
        -e "s|@RADARR_API_KEY@|$(cat ${config.age.secrets.radarr.path})|" \
        -e "s|@SEERR_API_KEY@|$(cat ${config.age.secrets.seerr.path})|" \
        -e "s|@JELLYFIN_PASSWORD@|$(cat ${config.age.secrets.jellyfin-admin.path})|" \
        ${applicationYmlTemplate} > /run/janitorr/application.yml
    '';
  };

  virtualisation.oci-containers.containers = {
    janitorr = {
      image = "ghcr.io/schaka/janitorr:jvm-stable";
      volumes = [
        "/run/janitorr/application.yml:/config/application.yml:ro"
        "/var/lib/janitorr/logs:/logs"
        "/storage:/storage"
      ];
      environment.TZ = "America/Los_Angeles";
      extraOptions = [
        "--user=${toString config.users.users.janitorr.uid}:${toString config.users.groups.janitorr.gid}"
        "--memory=256m"
        "--network=host"
      ];
      dependsOn = ["janitorr-stats"];
    };

    janitorr-stats = {
      image = "ghcr.io/schaka/janitorr-stats:stable-sqlite";
      volumes = [
        "${janitorrStatsApplicationYml}:/work/config/application.yml:ro"
        "/var/lib/janitorr-stats/data:/data"
      ];
      environment.TZ = "America/Los_Angeles";
      extraOptions = [
        "--user=${toString config.users.users.janitorr-stats.uid}:${toString config.users.groups.janitorr-stats.gid}"
        "--network=host"
      ];
    };
  };
}

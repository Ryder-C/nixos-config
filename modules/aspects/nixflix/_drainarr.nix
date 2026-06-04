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
in {
  services.drainarr = {
    enable = true;
    settings = {
      dry_run = false;

      disk_path = "/storage";
      target_usage = "75%";
      check_interval = "30m";
      min_added_age = "12d";

      stats = {
        kind = "janitorr";
        url = "http://localhost:${toString janitorrStatsPort}";
      };

      radarr = [
        {
          label = "movies";
          url = "http://localhost:7878";
          api_key = "d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1";
        }
      ];

      sonarr = [
        {
          label = "shows";
          url = "http://localhost:8989";
          api_key = "b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5";
        }
        {
          label = "anime";
          url = "http://localhost:8990";
          api_key = "c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6";
        }
      ];
    };
  };

  users = {
    groups.janitorr-stats = {};
    users.janitorr-stats = {
      isSystemUser = true;
      group = "janitorr-stats";
      description = "Janitorr-stats service user";
      home = "/var/lib/janitorr-stats";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/janitorr-stats 0750 janitorr-stats janitorr-stats -"
    "d /var/lib/janitorr-stats/data 0750 janitorr-stats janitorr-stats -"
  ];

  virtualisation.oci-containers.containers.janitorr-stats = {
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
}

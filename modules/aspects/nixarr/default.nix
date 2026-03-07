{inputs, ...}: {
  flake-file.inputs.nixarr = {
    url = "github:Ryder-C/nixarr/multi-instance-support";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.nixarr.nixos = {
    config,
    pkgs,
    lib,
    ...
  }: let
    allowOutsideAccess = false;
  in {
    imports = [
      inputs.nixarr.nixosModules.default
      ./_qbit-manage.nix
    ];

    users.users.cross-seed = {
      isSystemUser = true;
      group = "media";
      extraGroups = ["users"];
    };

    systemd.services = let
      requireStorage = {
        unitConfig.RequiresMountsFor = "/storage";
      };
    in {
      radarr = requireStorage;
      radarr-anime = requireStorage;
      sonarr = requireStorage;
      sonarr-anime = requireStorage;
      prowlarr = requireStorage;
      jellyfin = requireStorage;
      recyclarr = requireStorage;
      cross-seed = requireStorage // {
        serviceConfig = {
          ReadWritePaths = ["/storage/Torrents/cross-seed"];
          ReadOnlyPaths = ["/storage/media/library" "/storage/Torrents"];
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /storage/Torrents/cross-seed 0775 cross-seed media - -"
    ];

    age.secrets.cross-seed = {
      file = ../../../secrets/cross-seed.age;
      owner = "cross-seed";
      mode = "0400";
    };

    age.secrets.pia = {
      file = ../../../secrets/pia.age;
    };

    services = {
      cross-seed = {
        enable = true;
        user = "cross-seed";
        group = "media";
        settingsFile = config.age.secrets.cross-seed.path;
        settings = {
          useClientTorrents = true;
          delay = 30;
          linkCategory = "cross-seed";
          linkDirs = ["/storage/Torrents/cross-seed"];
          linkType = "symlink";
          flatLinking = false;
          matchMode = "partial";
          skipRecheck = true;
          autoResumeMaxDownload = 52428800;
          maxDataDepth = 3;
          includeSingleEpisodes = false;
          includeNonVideos = false;
          seasonFromEpisodes = 0.8;
          fuzzySizeThreshold = 0.02;
          excludeOlder = "365 days";
          excludeRecentSearch = "73 days";
          action = "inject";
          duplicateCategories = false;
          rssCadence = "10 minutes";
          searchCadence = "1 day";
          snatchTimeout = "30 seconds";
          searchTimeout = "2 minutes";
          searchLimit = 400;
          port = 2468;
        };
      };

      flaresolverr = {
        enable = true;
        openFirewall = false;
      };
      tailscale = {
        enable = true;
        openFirewall = true;
      };
    };

    nixarr = {
      enable = true;
      mediaDir = "/storage/media";
      stateDir = "/storage/.state";

      jellyfin.enable = true;

      prowlarr = {
        enable = true;
        openFirewall = allowOutsideAccess;
      };
      sonarr = {
        enable = true;
        openFirewall = allowOutsideAccess;
        instances."anime".enable = true;
      };
      radarr = {
        enable = true;
        openFirewall = allowOutsideAccess;
        instances."anime".enable = true;
      };

      readarr-audiobook = {
        enable = false;
        openFirewall = allowOutsideAccess;
      };

      recyclarr = {
        enable = true;
        configuration = import ./_recyclarr.nix;
      };
    };
  };
}

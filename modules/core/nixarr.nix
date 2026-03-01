{
  inputs,
  config,
  ...
}: let
  allowOutsideAccess = false;
in {
  imports = [inputs.nixarr.nixosModules.default];

  users.users.cross-seed = {
    isSystemUser = true;
    group = "media";
    extraGroups = ["users"];
  };

  systemd.services.cross-seed.serviceConfig = {
    ReadWritePaths = ["/storage/Torrents/cross-seed"];
    ReadOnlyPaths = ["/storage/media/library" "/storage/Torrents"];
  };

  systemd.tmpfiles.rules = [
    "d /storage/Torrents/cross-seed 0775 cross-seed media - -"
  ];

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

      instances = {
        "anime".enable = true;
      };
    };
    radarr = {
      enable = true;
      openFirewall = allowOutsideAccess;

      instances = {
        "anime".enable = true;
      };
    };

    readarr-audiobook = {
      enable = false;
      openFirewall = allowOutsideAccess;
    };

    recyclarr = {
      enable = false;
      configuration = {
        sonarr = {
          series = {
            base_url = "http://localhost:8989";
            api_key = "!env_var SONARR_API_KEY";

            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;

            # Create BOTH: WEB-2160p (general TV) and Anime (anime TV)
            include = [
              # General TV (highest quality WEB 2160p)
              {template = "sonarr-quality-definition-series";}
              {template = "sonarr-v4-quality-profile-web-2160p";}
              {template = "sonarr-v4-custom-formats-web-2160p";}

              # Anime TV (anime-specific sizes & CFs)
              {template = "sonarr-quality-definition-anime";}
              {template = "sonarr-v4-quality-profile-anime";}
              {template = "sonarr-v4-custom-formats-anime";}
            ];
          };
        };

        radarr = {
          movies = {
            base_url = "http://localhost:7878";
            api_key = "!env_var RADARR_API_KEY";

            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;

            # UHD Bluray + WEB for movies, plus Anime support (optional but handy)
            include = [
              {template = "radarr-quality-definition-movie";}
              {template = "radarr-quality-profile-uhd-bluray-web";}
              {template = "radarr-custom-formats-uhd-bluray-web";}

              {template = "radarr-quality-profile-anime";}
              {template = "radarr-custom-formats-anime";}
            ];
          };
        };
      };
    };
  };
}

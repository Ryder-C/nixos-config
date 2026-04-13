{inputs, ...}: {
  flake-file.inputs = {
    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Kept solely for the cross-seed NixOS module
    nixarr = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  ry.nixflix.nixos = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.nixflix.nixosModules.default
      inputs.nixarr.nixosModules.default
      ./_qbit-manage.nix
    ];

    # -- cross-seed (from nixarr module) --
    users.users.cross-seed = {
      isSystemUser = true;
      group = "media";
      extraGroups = ["users"];
    };

    # -- radarr-anime (manual, nixflix has no multi-instance) --
    users.users.radarr-anime = {
      isSystemUser = true;
      group = "media";
    };

    systemd.services = let
      requireStorage = {
        unitConfig.RequiresMountsFor = "/storage";
      };
    in {
      radarr = requireStorage;
      radarr-anime =
        requireStorage
        // {
          description = "Radarr (Anime)";
          after = ["network-online.target"];
          wants = ["network-online.target"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            Type = "simple";
            User = "radarr-anime";
            Group = "media";
            ExecStart = "${pkgs.radarr}/bin/Radarr -nobrowser -data=/storage/.state/radarr-anime";
            Restart = "on-failure";
            StateDirectory = "radarr-anime";
          };
        };
      sonarr = requireStorage;
      sonarr-anime = requireStorage;
      prowlarr = requireStorage;
      jellyfin = requireStorage;
      recyclarr = requireStorage;
      cross-seed =
        requireStorage
        // {
          serviceConfig = {
            ReadWritePaths = ["/storage/Torrents/cross-seed"];
            ReadOnlyPaths = ["/storage/media/library" "/storage/Torrents"];
          };
        };
    };

    systemd.tmpfiles.rules = [
      "d /storage/Torrents/cross-seed 0775 cross-seed media - -"
      "d /storage/.state/radarr-anime 0755 radarr-anime media - -"
    ];

    age.secrets.cross-seed = {
      file = ../../../secrets/cross-seed.age;
      owner = "cross-seed";
      mode = "0400";
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
    };

    nixflix = {
      enable = true;
      mediaDir = "/storage/media";
      stateDir = "/storage/.state";

      jellyfin = {
        enable = true;
        apiKey = "e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2"; # TODO: replace with real key or agenix secret
        users.ryder = {
          policy.isAdministrator = true;
          password = "ryder123"; # TODO: change on first login
        };
      };

      prowlarr = {
        enable = true;
        config = {
          apiKey = "a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4"; # TODO: replace with real key or agenix secret
          hostConfig.password = "ryder123"; # TODO: replace with real password
        };
      };

      sonarr = {
        enable = true;
        config = {
          apiKey = "b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5"; # TODO: replace with real key or agenix secret
          hostConfig.password = "ryder123";
        };
      };
      sonarr-anime = {
        enable = true;
        config = {
          apiKey = "c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6"; # TODO: replace with real key or agenix secret
          hostConfig.password = "ryder123";
        };
      };

      radarr = {
        enable = true;
        config = {
          apiKey = "d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1"; # TODO: replace with real key or agenix secret
          hostConfig.password = "ryder123";
        };
      };

      flaresolverr.enable = true;

      recyclarr = {
        enable = true;
        config = import ./_recyclarr.nix;
      };
    };
  };
}

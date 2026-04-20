{inputs, ry, ...}: {
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

  ry.nixflix = {
    includes = [ry.torrents];

    nixos = {
      config,
      pkgs,
      ...
    }: {
      imports = [
        inputs.nixflix.nixosModules.default
        inputs.nixarr.nixosModules.default
        ./_qbit-manage.nix
      ];

      ry.caddy.vhosts."media" = 8096;

      # -- cross-seed (from nixarr module) --
      users.users.cross-seed = {
        isSystemUser = true;
        group = "media";
        extraGroups = ["users"];
      };

      systemd.services = let
        requireStorage = {
          unitConfig.RequiresMountsFor = "/storage";
        };
        afterPia = {
          wants = ["pia-vpn.service"];
          after = ["pia-vpn.service"];
        };
        deps = requireStorage // afterPia;
      in {
        radarr = deps;
        sonarr = deps;
        sonarr-anime = deps;
        prowlarr = deps;
        jellyfin = requireStorage;
        recyclarr = deps;
        cross-seed =
          deps
          // {
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
        mediaDir = "/storage/media/library";
        stateDir = "/storage/.state";
        downloadsDir = "/storage/Torrents";

        jellyfin = {
          enable = true;
          apiKey = "e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2";
          openFirewall = true;
          users.ryder = {
            policy.isAdministrator = true;
            password = "ryder123";
          };
        };

        prowlarr = {
          enable = true;
          config = {
            apiKey = "a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4";
            hostConfig = {
              password = "ryder123";
              bindAddress = "0.0.0.0";
            };
          };
        };

        sonarr = {
          enable = true;
          config = {
            apiKey = "b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5"; # TODO: replace with real key or agenix secret
            hostConfig = {
              password = "ryder123";
              bindAddress = "0.0.0.0";
            };
          };
        };
        sonarr-anime = {
          enable = true;
          config = {
            apiKey = "c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6"; # TODO: replace with real key or agenix secret
            hostConfig = {
              password = "ryder123";
              bindAddress = "0.0.0.0";
            };
          };
        };

        radarr = {
          enable = true;
          config = {
            apiKey = "d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1"; # TODO: replace with real key or agenix secret
            hostConfig = {
              password = "ryder123";
              bindAddress = "0.0.0.0";
            };
          };
        };

        flaresolverr.enable = true;

        recyclarr = {
          enable = true;
          config = import ./_recyclarr.nix;
        };
      };
    };
  };
}

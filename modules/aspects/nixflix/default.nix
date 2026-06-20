{
  inputs,
  ry,
  ...
}: {
  flake-file.inputs = {
    vpnconfinement.url = "github:Maroka-chan/VPN-Confinement";
    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs."vpn-confinement".follows = "vpnconfinement";
    };
    # Kept solely for the cross-seed NixOS module
    nixarr = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.vpnconfinement.follows = "vpnconfinement";
    };
    drainarr = {
      url = "github:ryder-c/drainarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  ry.nixflix = {
    includes = [ry.torrents ry.caddy];

    nixos = {
      config,
      pkgs,
      lib,
      ...
    }: {
      imports = [
        inputs.nixflix.nixosModules.default
        inputs.nixarr.nixosModules.default
        inputs.drainarr.nixosModules.default

        ./_qui.nix
        ./_qbit-manage.nix
        ./_redirecterr.nix
        ./_autobrr.nix
        ./_drainarr.nix
        # (import ./_shoko.nix {inherit inputs;})
      ];

      ry.caddy.vhosts."ryder.rs" = {
        media = 8096;
        request = 5055;
      };

      ry.homepage.services = {
        "Media" = [
          {
            "Jellyfin" = {
              href = "https://media.ryder.rs";
              icon = "jellyfin";
              widget = {
                type = "jellyfin";
                url = "http://localhost:8096";
                key = "{{HOMEPAGE_FILE_JELLYFIN_KEY}}";
              };
            };
          }
          {
            "Seerr" = {
              href = "https://request.ryder.rs";
              icon = "seerr";
              widget = {
                type = "seerr";
                url = "http://localhost:5055";
                key = "{{HOMEPAGE_FILE_SEERR_KEY}}";
              };
            };
          }
        ];
        "Arr" = [
          {
            "Radarr" = {
              href = "http://${config.networking.hostName}:7878";
              icon = "radarr";
              widget = {
                type = "radarr";
                url = "http://localhost:7878";
                key = "d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1";
              };
            };
          }
          {
            "Sonarr" = {
              href = "http://${config.networking.hostName}:8989";
              icon = "sonarr";
              widget = {
                type = "sonarr";
                url = "http://localhost:8989";
                key = "b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5";
              };
            };
          }
          {
            "Sonarr Anime" = {
              href = "http://${config.networking.hostName}:8990";
              icon = "sonarr";
              widget = {
                type = "sonarr";
                url = "http://localhost:8990";
                key = "c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6";
              };
            };
          }
          {
            "Prowlarr" = {
              href = "http://${config.networking.hostName}:9696";
              icon = "prowlarr";
              widget = {
                type = "prowlarr";
                url = "http://localhost:9696";
                key = "a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4";
              };
            };
          }
        ];
      };

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
        # nixflix's hardening sets ProtectSystem=strict with separate
        # ReadWritePaths= for /storage/Torrents and /storage/media/library/*,
        # putting them on different bind mounts inside the service's namespace.
        # link() then returns EXDEV across them and the *arrs fall back to copy.
        # Collapse to a single covering bind mount so hardlinks work.
        hardlinkFix.serviceConfig.ReadWritePaths = lib.mkForce ["/storage"];
      in {
        radarr = deps // hardlinkFix;
        sonarr = deps // hardlinkFix;
        sonarr-anime = deps // hardlinkFix;
        prowlarr = deps;
        jellyfin = requireStorage;
        recyclarr = deps;
        cross-seed =
          deps
          // {
            serviceConfig = {
              ReadWritePaths = lib.mkForce ["/storage"];
              AmbientCapabilities = ["CAP_FOWNER"];
              CapabilityBoundingSet = ["CAP_FOWNER"];
            };
          };
        prowlarr-indexers.enable = lib.mkForce false;

        homepage-dashboard.environment = {
          HOMEPAGE_FILE_JELLYFIN_KEY = config.age.secrets.jellyfin.path;
          HOMEPAGE_FILE_SEERR_KEY = config.age.secrets.seerr.path;
        };
      };

      systemd.tmpfiles.rules = [
        "d /storage/Torrents/cross-seed 0775 cross-seed media - -"
      ];

      age.secrets = {
        autobrr = {
          file = ../../../secrets/autobrr.age;
          mode = "0400";
        };
        cross-seed = {
          file = ../../../secrets/cross-seed.age;
          owner = "cross-seed";
          mode = "0400";
        };
        jellyfin = {
          file = ../../../secrets/jellyfin.age;
          mode = "0444";
        };
        jellyfin-admin.file = ../../../secrets/jellyfin-admin.age;
        seerr = {
          file = ../../../secrets/seerr.age;
          mode = "0444";
        };
        sonarr.file = ../../../secrets/sonarr.age;
        sonarr-anime.file = ../../../secrets/sonarr-anime.age;
        radarr.file = ../../../secrets/radarr.age;
        qui.file = ../../../secrets/qui.age;
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
            linkType = "hardlink";
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
          openFirewall = true;
          apiKey._secret = config.age.secrets.jellyfin.path;
          users.ryder = {
            policy.isAdministrator = true;
            password = "ryder123";
          };

          encoding = {
            enableHardwareEncoding = true;
            enableEnhancedNvdecDecoder = true;
            enableTonemapping = true;
            hardwareAccelerationType = "nvenc";
          };

          system.trickplayOptions = {
            enableHwAcceleration = true;
            enableKeyFrameOnlyExtraction = true;
          };

          branding.customCss = ''@import url("https://cdn.jsdelivr.net/gh/lscambo13/ElegantFin@main/Theme/ElegantFin-jellyfin-theme-build-latest-minified.css");'';
        };

        seerr = {
          enable = true;
          openFirewall = true;
          apiKey._secret = config.age.secrets.seerr.path;
          jellyfin = {
            adminPassword._secret = config.age.secrets.jellyfin-admin.path;
            # enableAllLibraries = false;
            # libraryFilter.names = ["Anime" "Movies" "Shows"];
          };
        };

        prowlarr = {
          enable = true;
          openFirewall = true;
          config = {
            apiKey._secret = pkgs.writeText "prowlarr-apikey" "a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4";
            hostConfig = {
              password = "ryder123";
            };
          };
        };

        sonarr = {
          enable = true;
          openFirewall = true;
          config = {
            apiKey._secret = config.age.secrets.sonarr.path;
            hostConfig = {
              password = "ryder123";
            };
          };
        };
        sonarr-anime = {
          enable = true;
          openFirewall = true;
          config = {
            apiKey._secret = config.age.secrets.sonarr-anime.path;
            hostConfig = {
              password = "ryder123";
            };
          };
        };

        radarr = {
          enable = true;
          openFirewall = true;
          config = {
            apiKey._secret = config.age.secrets.radarr.path;
            hostConfig = {
              password = "ryder123";
            };
          };
        };

        flaresolverr.enable = true;

        recyclarr = {
          enable = true;
          config = import ./_recyclarr.nix;
          cleanupUnmanagedProfiles = {
            enable = true;
            managedProfiles = ["movies" "shows" "anime"];
          };
        };
      };
    };
  };
}

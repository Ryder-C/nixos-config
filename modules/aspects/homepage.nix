{
  ry.homepage.nixos = {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      allowedHosts = "fornax.stork-mulley.ts.net:8082";

      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/storage";
            expanded = true;
          };
        }
        {
          datetime = {
            text_size = "xl";
            format = {
              dateStyle = "long";
              timeStyle = "short";
              hourCycle = "h23";
            };
          };
        }
      ];

      services = [
        {
          "Game" = [
            {
              "Minecraft" = {
                icon = "minecraft";
                widget = {
                  type = "minecraft";
                  url = "udp://localhost:25565";
                };
              };
            }
          ];
        }
        {
          "Media" = [
            {
              "Jellyfin" = {
                href = "https://media.ryder.rs";
                icon = "jellyfin";
                widget = {
                  type = "jellyfin";
                  url = "http://localhost:8096";
                  key = "e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2";
                };
              };
            }
            {
              "Ente" = {
                href = "https://photos.ryder.rs";
                icon = "ente";
              };
            }
          ];
        }
        {
          "Downloads" = [
            {
              "qBittorrent" = {
                href = "http://fornax.stork-mulley.ts.net:8080";
                icon = "qbittorrent";
                widget = {
                  type = "qbittorrent";
                  url = "http://localhost:8080";
                };
              };
            }
          ];
        }
        {
          "Arr" = [
            {
              "Radarr" = {
                href = "http://fornax.stork-mulley.ts.net:7878";
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
                href = "http://fornax.stork-mulley.ts.net:8989";
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
                href = "http://fornax.stork-mulley.ts.net:8990";
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
                href = "http://fornax.stork-mulley.ts.net:9696";
                icon = "prowlarr";
                widget = {
                  type = "prowlarr";
                  url = "http://localhost:9696";
                  key = "a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4";
                };
              };
            }
          ];
        }
      ];
    };
  };
}

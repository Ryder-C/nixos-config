{
  inputs,
  ry,
  ...
}: {
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia-shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  ry = {
    noctalia.nixos = _: {
      nix.settings = {
        substituters = ["https://noctalia.cachix.org"];
        trusted-public-keys = ["noctalia.cachix.org-1:X+I9x9j4W6h6q5lG2G8uX+5f6L2yU8K5o9y9U+L6J9o="];
      };
    };

    noctalia.homeManager = {
      config,
      lib,
      pkgs,
      ...
    }: let
      niriEnabled = config.programs.niri.enable;
    in {
      imports = [inputs.noctalia.homeModules.default];

      home.packages = with pkgs; [
        satty
        fastfetch
      ];

      programs.noctalia = {
        enable = true;
        package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

        settings = {
          shell = {
            polkit_agent = true;
            avatar_path = "${config.home.homeDirectory}/.face";
            corner_radius_scale = 1.0;
            clipboard_enabled = true;
            niri_overview_type_to_launch_enabled = true;
            settings_show_advanced = true;
            screenshot = {
              pipe_to_command = true;
              pipe_command = "satty -f -";
            };
          };

          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Catppuccin";
          };

          weather = {
            enabled = true;
            unit = "imperial";
          };

          location = {
            address = "Santa Cruz, United States";
          };

          wallpaper = {
            enabled = true;
            directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
            transition_on_startup = true;
            automation = {
              enabled = false;
              order = "random";
              recursive = true;
            };
          };

          system.monitor.enabled = true;

          idle.behavior = {
            lock = {
              timeout = 600;
              enabled = true;
              action = "lock";
            };
            "screen-off" = {
              timeout = 330;
              enabled = true;
              action = "screen_off";
            };
            "rgb-off" = {
              timeout = 330;
              command = "openrgb -p off";
              resume_command = "openrgb -p main";
              enabled = true;
            };
          };

          bar.main = {
            position = "top";
            background_opacity = 0.93;
            capsule = true;
            margin_edge = 0;
            margin_ends = 0;
            padding = 7;
            radius = 0;
            start = ["control-center" "workspaces" "sysmon_cpu"];
            center = ["clock_date" "clock_time" "weather"];
            end = ["tray" "network" "bluetooth" "notifications"];
          };

          widget = {
            "control-center" = {
              glyph = "snowflake";
            };
            workspaces = {
              type = "workspaces";
              display = "none";
            };
            sysmon_cpu = {
              type = "sysmon";
              stat = "cpu_usage";
            };
            clock_date = {
              type = "clock";
              format = "{:%a, %b %d}";
            };
            clock_time = {
              type = "clock";
              format = "{:%-I:%M %p}";
            };
            network = {
              type = "network";
              show_label = false;
            };
            bluetooth = {
              type = "bluetooth";
              show_label = false;
            };
            tray = {
              type = "tray";
              pinned = ["Battery Status"];
            };
          };
        };
      };

      # Niri-specific integration
      programs.niri.settings = lib.mkIf niriEnabled {
        spawn-at-startup = lib.mkAfter [
          {command = ["noctalia"];}
        ];

        binds = let
          msg = ["noctalia" "msg"];
        in {
          "Mod+Space" = {
            action.spawn = msg ++ ["panel-toggle" "launcher"];
            hotkey-overlay.title = "Toggle Application Launcher";
          };
          "Mod+Y" = {
            action.spawn = msg ++ ["panel-toggle" "control-center" "notifications"];
            hotkey-overlay.title = "Toggle Notifications";
          };
          "Mod+Comma" = {
            action.spawn = msg ++ ["settings-toggle"];
            hotkey-overlay.title = "Toggle Settings";
          };
          "Mod+X" = {
            action.spawn = msg ++ ["panel-toggle" "session"];
            hotkey-overlay.title = "Toggle Power Menu";
          };
          "Mod+V" = {
            action.spawn = msg ++ ["panel-toggle" "clipboard"];
            hotkey-overlay.title = "Toggle Clipboard Manager";
          };

          # Volume Keys (via noctalia for OSD)
          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn = msg ++ ["volume-up"];
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn = msg ++ ["volume-down"];
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action.spawn = msg ++ ["volume-mute"];
          };

          # Search key (Mac F4) opens the launcher
          "XF86Search".action.spawn = msg ++ ["panel-toggle" "launcher"];
        };

        layer-rules = [
          {
            matches = [{namespace = "^noctalia-notification";}];
            block-out-from = "screencast";
          }
        ];
      };
    };

    noctalia-praxis = {
      includes = [ry.gpu-screen-recorder];
    };

    noctalia-sputnik = {
      homeManager = {lib, ...}: {
        programs.noctalia.settings.bar.main = {
          start = lib.mkForce ["control-center" "workspaces" "clock_date" "weather" "clock_time"];
          center = lib.mkForce [];
          end = lib.mkForce ["tray" "network" "bluetooth" "notifications" "battery_graphic"];
        };
        programs.noctalia.settings.widget.battery_graphic = {
          type = "battery";
          display_mode = "graphic";
        };
      };
    };
  };
}

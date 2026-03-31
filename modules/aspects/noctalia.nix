{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia-shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.noctalia.nixos = {...}: {
    nix.settings = {
      substituters = ["https://noctalia.cachix.org"];
      trusted-public-keys = ["noctalia.cachix.org-1:X+I9x9j4W6h6q5lG2G8uX+5f6L2yU8K5o9y9U+L6J9o="];
    };
  };

  ry.noctalia.homeManager = {
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
      gpu-screen-recorder
      fastfetch
    ];

    programs.noctalia-shell = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          screen-recorder.enabled = true;
          polkit-agent.enabled = true;
          weather-indicator.enabled = true;
          catwalk.enabled = true;
        };
      };

      pluginSettings = {
        screen-recorder = {
          replayEnabled = true;
          replayDuration = "30";
          frameRate = "30";
          resolution = "1920x1080";
        };
      };

      settings = {
        bar = {
          barType = "simple";
          position = "top";
          density = "default";
          showCapsule = true;
          backgroundOpacity = 0.93;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "Workspace";
                labelMode = "none";
                showBadge = true;
              }
              {
                id = "plugin:catwalk";
              }
            ];
            center = [
              {
                id = "Clock";
                formatHorizontal = "ddd, MMM dd";
              }
              {
                id = "plugin:weather-indicator";
              }
              {
                id = "Clock";
                formatHorizontal = "h:mm AP";
              }
            ];
            right = [
              {
                id = "plugin:screen-recorder";
              }
              {
                id = "Tray";
                pinned = ["Battery Status"];
              }
              {
                id = "Network";
                displayMode = "onhover";
              }
              {
                id = "Bluetooth";
                displayMode = "onhover";
              }
              {
                id = "NotificationHistory";
                showUnreadBadge = true;
              }
              {
                id = "Battery";
                displayMode = "graphic-clean";
              }
            ];
          };
        };
        general = {
          avatarImage = "${config.home.homeDirectory}/.face";
          clockStyle = "custom";
          clockFormat = "hh\nmm";
          lockOnSuspend = true;
          radiusRatio = 1;
        };
        location = {
          name = "Santa Cruz, United States";
          useFahrenheit = true;
          use12hourFormat = true;
        };
        wallpaper = {
          directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          viewMode = "recursive";
          wallpaperChangeMode = "random";
        };
        colorSchemes = {
          predefinedScheme = "Catppuccin";
          darkMode = true;
        };
        idle = {
          enabled = true;
          screenOffTimeout = 330;
          lockTimeout = 600;
          suspendTimeout = 0;
          customCommands = builtins.toJSON [
            {
              name = "Turn off rgb";
              timeout = 330;
              command = "openrgb -p off";
              resumeCommand = "openrgb -p main";
            }
          ];
        };
        appLauncher = {
          enableClipboardHistory = true;
          overviewLayer = true;
          terminalCommand = "alacritty -e";
          screenshotAnnotationTool = "satty -f -";
        };
        audio = {
          preferredPlayer = "spotify";
        };
        systemMonitor = {
          enableDgpuMonitoring = true;
        };
      };
    };

    # Niri-specific integration
    programs.niri.settings = lib.mkIf niriEnabled {
      spawn-at-startup = lib.mkAfter [
        {command = ["noctalia-shell"];}
      ];

      binds = let
        noctalia-ipc = ["noctalia-shell" "ipc" "call"];
      in {
        "Mod+Space" = {
          action.spawn = noctalia-ipc ++ ["launcher" "toggle"];
          hotkey-overlay.title = "Toggle Application Launcher";
        };
        "Mod+Y" = {
          action.spawn = noctalia-ipc ++ ["notifications" "toggleHistory"];
          hotkey-overlay.title = "Toggle Notification Center";
        };
        "Mod+Comma" = {
          action.spawn = noctalia-ipc ++ ["settings" "toggle"];
          hotkey-overlay.title = "Toggle Settings";
        };
        "Mod+P" = {
          action.spawn = noctalia-ipc ++ ["notepad" "toggle"];
          hotkey-overlay.title = "Toggle Notepad";
        };
        "Mod+X" = {
          action.spawn = noctalia-ipc ++ ["sessionMenu" "toggle"];
          hotkey-overlay.title = "Toggle Power Menu";
        };
        "Mod+V" = {
          action.spawn = noctalia-ipc ++ ["launcher" "clipboard"];
          hotkey-overlay.title = "Toggle Clipboard Manager";
        };
      };

      layer-rules = [
        {
          matches = [{namespace = "^noctalia-notifications";}];
          block-out-from = "screencast";
        }
      ];
    };
  };
}

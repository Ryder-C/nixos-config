{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  programs.hyprpanel = {
    enable = true;

    systemd.enable = true;
    hyprland.enable = true;
    overwrite.enable = true;

    settings = {
      layout = {
        "bar.layouts" = {
          "0" = {
            left = ["dashboard" "workspaces" "media"];
            middle = ["clock"];
            right = ["volume" "network" "bluetooth" "systray" "notifications"];
          };
          "1" = {
            left = ["dashboard" "workspaces" "media"];
            middle = ["clock"];
            right = ["volume" "notifications"];
          };
          "2" = {
            left = ["dashboard" "workspaces" "media"];
            middle = ["clock"];
            right = ["volume" "notifications"];
          };
        };
      };

      bar = {
        launcher.autoDetectIcon = true;
        workspaces = {
          show_icons = false;
          monitorSpecific = false;
        };
      };

      menus = {
        clock = {
          time = {
            military = false;
            hideSeconds = true;
          };
          weather.unit = "imperial";
        };

        dashboard = {
          directories.enabled = false;
          stats.enable_gpu = true;

          shortcuts = {
            left = {
              shortcut1 = {
                icon = "";
                command = "alacritty";
                tooltip = "Terminal";
              };
              shortcut2.command = "spotify";
              shortcut3.command = "vesktop";
              shortcut4.command = "fuzzel";
            };
          };
        };
      };

      theme = {
        name = "catppuccin_mocha_split";
        bar = {
          transparent = false;
          scaling = 75;

          menus = {
            menu = {
              notifications.scaling = 75;
              dashboard.scaling = 75;
              battery.scaling = 75;
              bluetooth.scaling = 75;
              clock.scaling = 75;
              media.scaling = 75;
              network.scaling = 75;
              power.scaling = 75;
              volume.scaling = 75;
            };
            popover.scaling = 75;
          };
        };
        notification.scaling = 75;
        osd.scaling = 75;
        tooltip.scaling = 75;
      };

      # theme.font = {
      #   name = "CaskaydiaCove NF";
      #   size = "16px";
      # };
    };
  };
}

{pkgs, ...}: {
  home.packages = with pkgs; [
    python313Packages.gpustat
  ];

  programs.hyprpanel = {
    enable = true;
    # package = inputs.hyprpanel.packages.${pkgs.system}.hyprpanel;

    systemd.enable = true;

    settings = {
      scalingPriority = "hyprland";

      bar = {
        layouts = {
          "DP-4" = {
            left = ["dashboard" "workspaces" "media" "volume"];
            middle = ["clock"];
            right = ["network" "bluetooth" "cputemp" "systray" "hypridle" "notifications"];
          };
          "*" = {
            left = ["dashboard" "workspaces" "media" "volume"];
            middle = ["clock"];
            right = ["network" "bluetooth" "cputemp" "notifications"];
          };
        };

        launcher.autoDetectIcon = true;
        workspaces = {
          show_icons = false;
          monitorSpecific = false;
        };
        customModules.cpuTemp.sensor = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp1_input";
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

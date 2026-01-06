{
  inputs,
  username,
  ...
}: {
  imports = [inputs.noctalia.homeModules.default];

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;

    settings = {
      templates = {
        gtk = true;
        qt = true;
      };
      location = {
        name = "San Diego";
        use12hourFormat = true;
        useFahrenheit = true;
      };
      colorSchemes.predefinedScheme = "Catppuccin";
      systemMonitor.enableNvidiaGpu = true;
      wallpaper = {
        directory = "/home/${username}/Pictures/wallpapers";
        recursiveSearch = true;
      };
      brightness.enableDdcSupport = true;
      appLauncher = {
        enableClipboardHistory = true;
        terminalCommand = "alacritty -e";
      };

      bar = {
        widgets = {
          left = [
            {
              icon = "rocket";
              id = "CustomButton";
              leftClickExec = "noctalia-shell ipc call launcher toggle";
            }
            {
              id = "Workspace";
            }
            {
              id = "SystemMonitor";
            }
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Clock";
              usePrimaryColor = false;
              formatHorizontal = "h:mm AP";
            }
          ];
          right = [
            {
              id = "Tray";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "NotificationHistory";
            }
            # {
            #   id = "Battery";
            # }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "ControlCenter";
            }
          ];
        };
      };
    };
  };
}

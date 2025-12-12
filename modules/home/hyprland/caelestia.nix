{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.caelestia-shell.homeManagerModules.default];

  home.packages = with pkgs; [
    material-icons
    material-symbols
    material-design-icons

    adwaita-icon-theme
    hicolor-icon-theme
    # papirus-icon-theme
    kdePackages.qtsvg
  ];

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      general = {
        apps.terminal = ["alacritty"];

        idle = {
          lockBeforeSleep = true;
          inhibitWhenAudio = true;
          timeouts = [
            {
              timeout = 180;
              idleAction = "lock";
            }
            {
              timeout = 300;
              idleAction = "dpms off";
              returnAction = "dpms on";
            }
            # {
            #   timeout = 600;
            #   idleAction = ["systemctl" "suspend-then-hibernate"];
            # }
          ];
        };
      };

      bar = {
        tray.compact = true;
        status = {
          showBattery = false;
        };
      };
      paths.wallpaperDir = "~/Pictures/wallpapers";
      services = {
        smartScheme = false;
        useFarenheit = false;
      };
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}

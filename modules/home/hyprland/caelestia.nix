{inputs, ...}: {
  imports = [inputs.caelestia-shell.homeManagerModules.default];

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
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

{
  pkgs,
  lib,
  inputs,
  username,
  host,
  ...
}: {
  services.displayManager.dms-greeter = {
    enable = true;
    compositor = {
      name = "niri";
      customConfig =
      if (host == "desktop")
      then ''
        output "DP-2" {
            scale 1.500000
            position x=2560 y=0
            mode "3840x2160@59.997000"
        }
        output "DP-3" {
            scale 1.500000
            transform "normal"
            position x=0 y=0
            mode "3840x2160@239.996000"
        }
        hotkey-overlay { skip-at-startup; }
      ''
      else if (host == "laptop")
      then ''
        debug {
            render-drm-device "/dev/dri/renderD128"
        }
      ''
      else "";
    };

    configHome = "/home/${username}";
    configFiles = [
      "/home/${username}/.config/DankMaterialShell/settings.json"
      "/home/${username}/.local/state/DankMaterialShell/session.json"
    ];

    package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}

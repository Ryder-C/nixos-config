{inputs, ...}: {
  flake-file.inputs.dms = {
    url = "github:AvengeMedia/DankMaterialShell/stable";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.greetd.nixos = {config, pkgs, ...}: {
    services.displayManager.dms-greeter = {
      enable = true;
      compositor = {
        name = "niri";
        customConfig =
          if (config.networking.hostName == "desktop")
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
          else if (config.networking.hostName == "laptop")
          then ''
            debug {
                render-drm-device "/dev/dri/renderD128"
            }
            hotkey-overlay { skip-at-startup; }
          ''
          else "";
      };

      configHome = "/home/ryder";
      configFiles = [
        "/home/ryder/.config/DankMaterialShell/settings.json"
        "/home/ryder/.local/state/DankMaterialShell/session.json"
      ];

      package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}

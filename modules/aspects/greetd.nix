{inputs, ...}: {
  flake-file.inputs.dms = {
    url = "github:AvengeMedia/DankMaterialShell/stable";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry = {
    greetd.nixos = {pkgs, ...}: {
      services.displayManager.dms-greeter = {
        enable = true;
        compositor.name = "niri";
        configHome = "/home/ryder";
        configFiles = [
          "/home/ryder/.config/DankMaterialShell/settings.json"
          "/home/ryder/.local/state/DankMaterialShell/session.json"
        ];
        package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
    };

    greetd-desktop.nixos = {
      services.displayManager.dms-greeter.compositor.customConfig = ''
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
      '';
    };

    greetd-laptop.nixos = {
      services.displayManager.dms-greeter.compositor.customConfig = ''
        debug {
            render-drm-device "/dev/dri/renderD128"
        }
        hotkey-overlay { skip-at-startup; }
      '';
    };
  };
}

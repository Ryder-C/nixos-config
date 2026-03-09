{inputs, ...}: {
  flake-file.inputs = {
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-citizen = {
      url = "github:LovingMelody/nix-citizen";
      inputs.nix-gaming.follows = "nix-gaming";
    };
  };

  ry.star-citizen.nixos = {pkgs, ...}: {
    imports = [inputs.nix-citizen.nixosModules.default];

    environment.systemPackages = [inputs.nix-citizen.packages.${pkgs.stdenv.hostPlatform.system}.lug-helper];

    programs.rsi-launcher = {
      enable = true;
      enforceWaylandDrv = false;
      umu.enable = false;
      gamescope = {
        enable = false;
        args = [
          "-f"
          "-w"
          "3840"
          "-h"
          "2160"
          "-W"
          "3840"
          "-H"
          "2160"
          "--force-grab-cursor"
          "--backend"
          "sdl"
        ];
      };
      preCommands = ''
        # Disable VR client DLLs so DXVK skips OpenVR initialization
        export WINEDLLOVERRIDES="vrclient=d;vrclient_x64=d;openvr_api_dxvk=d;''${WINEDLLOVERRIDES}"
      '';
    };
  };
}

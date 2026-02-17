{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nix-citizen.nixosModules.default];

  environment.systemPackages = [inputs.nix-citizen.packages.${pkgs.stdenv.hostPlatform.system}.lug-helper];

  programs.rsi-launcher = {
    enable = true;

    enforceWaylandDrv = true;
    umu.enable = true;
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
        "sdl" # Required for niri — fixes cursor/input issues
      ];
    };
  };
}

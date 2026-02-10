{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nix-citizen.nixosModules.default];

  environment.systemPackages = [inputs.nix-citizen.packages.${pkgs.stdenv.hostPlatform.system}.lug-helper];

  programs.rsi-launcher = {
    enable = true;

    # Uses wine-astral by default (recommended, no staging, LUG patches, EAC bridge)
    # Do NOT enable umu — Proton GE breaks EAC with error 70003

    preCommands = ''
      # Unset WLR_NO_HARDWARE_CURSORS — it's for niri, not gamescope's internal wlroots
      unset WLR_NO_HARDWARE_CURSORS
    '';

    gamescope = {
      enable = true;
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

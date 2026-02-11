{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nix-citizen.nixosModules.default];

  environment.systemPackages = [inputs.nix-citizen.packages.${pkgs.stdenv.hostPlatform.system}.lug-helper];

  programs.rsi-launcher = {
    enable = true;

    # Using umu-launcher + Proton GE

    preCommands = ''
      # Unset WLR_NO_HARDWARE_CURSORS — it's for niri, not gamescope's internal wlroots
      unset WLR_NO_HARDWARE_CURSORS

      # Expose Nvidia Vulkan ICDs so DXVK inside umu/proton can detect the GPU
      export VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json
    '';

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

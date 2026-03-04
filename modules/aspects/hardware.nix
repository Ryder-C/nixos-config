_: {
  ry.hardware.nixos = {pkgs, ...}: {
    hardware = {
      enableAllFirmware = true;
      uinput.enable = true;
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          vulkan-loader
          vulkan-tools
        ];
      };
      keyboard.qmk.enable = true;
    };
    hardware.enableRedistributableFirmware = true;
  };
}

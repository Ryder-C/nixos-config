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

  ry.hardware-x86.nixos = {config, lib, ...}:
    lib.mkIf config._ry.isX86 {
      hardware = {
        flipperzero.enable = true;
        steam-hardware.enable = true;
        opentabletdriver.enable = true;
        graphics.enable32Bit = true;
      };
    };
}

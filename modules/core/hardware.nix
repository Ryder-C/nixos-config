{pkgs, ...}: {
  hardware = {
    enableAllFirmware = true;
    flipperzero.enable = true;
    steam-hardware.enable = true;
    opentabletdriver.enable = true;
    uinput.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-tools
      ];
    };

    keyboard.qmk.enable = true;
  };
  hardware.enableRedistributableFirmware = true;
}

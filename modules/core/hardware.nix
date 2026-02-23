{
  pkgs,
  host,
  lib,
  ...
}: {
  hardware = {
    enableAllFirmware = true;
    flipperzero.enable = host != "laptop";
    steam-hardware.enable = host != "laptop";
    opentabletdriver.enable = host != "laptop";
    uinput.enable = true;
    graphics = {
      enable = true;
      enable32Bit = host != "laptop";
      extraPackages = with pkgs; [
        vulkan-loader
        vulkan-tools
      ];
    };

    keyboard.qmk.enable = true;
  };
  hardware.enableRedistributableFirmware = true;
}

{pkgs, ...}: {
  # options.hardware.flipperzero.enable = true;
  hardware = {
    enableAllFirmware = true;
    flipperzero.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      # extraPackages = with pkgs; [
      # ];
    };

    keyboard.qmk.enable = true;
  };
  hardware.enableRedistributableFirmware = true;
}

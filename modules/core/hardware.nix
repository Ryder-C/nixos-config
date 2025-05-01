{pkgs, ...}: {
  # options.hardware.flipperzero.enable = true;
  hardware = {
    flipperzero.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
      ];
    };

    keyboard.qmk.enable = true;
  };
  hardware.enableRedistributableFirmware = true;
}

{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # bluetooth manager
  services.blueman.enable = true;
}

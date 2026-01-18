{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # bluetooth manager
  services.blueman.enable = true;
}

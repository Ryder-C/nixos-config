{inputs, ...}: {
  imports = [inputs.rypkgs.nixosModules.bluevein];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # bluetooth manager
  services.blueman.enable = true;

  services.bluevein.enable = true;
}

{inputs, ...}: {
  imports = [inputs.rypkgs.nixosModules.bluevein];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  services = {
    # disable ghost MediaTek bluetooth adapter (0e8d:0616)
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", ATTR{idProduct}=="0616", ATTR{authorized}="0"
    '';

    # bluetooth manager
    blueman.enable = true;

    bluevein.enable = true;
  };
}

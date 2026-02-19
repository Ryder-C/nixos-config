{host, lib, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # disable ghost MediaTek bluetooth adapter (0e8d:0616)
  services.udev.extraRules = lib.optionalString (host != "laptop") ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", ATTR{idProduct}=="0616", ATTR{authorized}="0"
  '';
}

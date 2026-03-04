_: {
  ry.bluetooth.nixos = {config, lib, ...}: {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    # disable ghost MediaTek bluetooth adapter (0e8d:0616) on desktop
    services.udev.extraRules = lib.optionalString config._ry.isX86 ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", ATTR{idProduct}=="0616", ATTR{authorized}="0"
    '';
  };
}

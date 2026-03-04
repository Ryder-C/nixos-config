_: {
  ry.bootloader.nixos = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd.systemd.enable = true;
      initrd.systemd.network.wait-online.enable = false;
      supportedFilesystems = ["ntfs"];
      plymouth.enable = false;
    };
  };

}

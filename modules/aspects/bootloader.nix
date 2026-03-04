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

  ry.bootloader-x86.nixos = {config, pkgs, lib, ...}:
    lib.mkIf config._ry.isX86 {
      boot = {
        supportedFilesystems = ["bcachefs"];
        kernelPackages = pkgs.linuxPackages_zen;
        kernelParams = [
          "nvidia-drm.modeset=1"
          "nvidia-drm.fbdev=1"
        ];
      };
    };
}

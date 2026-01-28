{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.systemd.enable = true;
    initrd.systemd.network.wait-online.enable = false;
    supportedFilesystems = ["ntfs" "bcachefs"];
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = ["nvidia-drm.modeset=1" "nvidia-drm.fbdev=1"];

    plymouth.enable = false;
  };
}

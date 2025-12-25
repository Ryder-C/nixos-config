{pkgs, ...}: {
  boot = {
    loader.systemd-boot = {
      enable = true;
      # configurationLimit = 10;
    };
    initrd.systemd.network.wait-online.enable = false;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = ["nvidia-drm.modeset=1" "nvidia-drm.fbdev=1"];
  };
}

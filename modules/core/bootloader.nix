{pkgs, ...}: {
  boot.loader.systemd-boot = {
    enable = true;
    # configurationLimit = 10;
  };
  boot.initrd.systemd.network.wait-online.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
}

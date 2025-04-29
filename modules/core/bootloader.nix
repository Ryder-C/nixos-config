{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  # boot.initrd.systemd.network.wait-online.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.supportedFilesystems = ["ntfs"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
}

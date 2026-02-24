{
  pkgs,
  host,
  lib,
  ...
}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.systemd.enable = true;
    initrd.systemd.network.wait-online.enable = false;
    supportedFilesystems =
      ["ntfs"]
      ++ lib.optionals (host != "laptop") ["bcachefs"];
    kernelPackages = lib.mkIf (host != "laptop") pkgs.linuxPackages_zen;
    kernelParams = lib.optionals (host != "laptop") [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];

    plymouth.enable = false;
  };
}

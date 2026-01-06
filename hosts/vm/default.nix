{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

  # kvm/qemu doesn't use UEFI firmware mode by default.
  # so we force-override the setting here
  # and configure GRUB instead.
  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    grub = {
      enable = true;
      device = "/dev/vda";
      useOSProber = false;
    };
  };

  services.openssh = {
    enable = false;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      PermitRootLogin = "yes";
    };
  };
}

{
  ry.services.nixos = {lib, ...}: {
    systemd = {
      user.services.niri-flake-polkit.enable = false;
      services.systemd-networkd-wait-online.enable = lib.mkForce false;
    };

    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = {
          enable = true;
          addresses = true;
          domain = true;
          hinfo = true;
          userServices = true;
          workstation = true;
        };
      };
      gvfs.enable = true;
      tumbler.enable = true;
      gnome.gnome-keyring.enable = true;
      dbus.enable = true;
      fstrim.enable = true;
      seatd.enable = true;
      input-remapper.enable = true;
    };
  };
}

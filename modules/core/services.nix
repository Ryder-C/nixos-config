{
  config,
  inputs,
  ...
}: {
  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    fstrim.enable = true;
    flatpak.enable = true;

    hardware.openrgb.enable = true;

    # pia-vpn = {
    #   enable = true;
    #   certificateFile = ../../ca.rsa.2048.crt;
    #   environmentFile = config.age.secrets.pia.path;
    # };
  };
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=poweroff
  '';
}

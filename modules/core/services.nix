{
  config,
  pkgs,
  inputs,
  ...
}: {
  systemd.user.services = {
    start_zmk_battery_monitor = {
      enable = true;
      description = "Start ZMK battery monitor";
      script = ''
        ${pkgs.zmkBATx}/bin/zmkbatx
      '';
      wantedBy = ["default.target"];
    };
  };
  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    fstrim.enable = true;
    flatpak.enable = true;

    hardware.openrgb.enable = true;

    # pia-vpn = {
    #   enable = true;
    #   certificateFile = ../../ca.rsa.4096.crt;
    #   region = "ca_vancouver";
    #   environmentFile = config.age.secrets.pia.path;
    #
    #   portForward = {
    #     enable = true;
    #     script = ''
    #       export $(cat transmission-rpc.env | xargs)
    #       ${pkgs.transmission_4-qt}/bin/transmission-remote --authenv --port $port || true
    #     '';
    #   };
    # };

    transmission = {
      enable = true;
      settings.rpc-bind-address = "0.0.0.0";
    };
  };
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=poweroff
  '';
}

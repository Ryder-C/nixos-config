{username, ...}: {
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
      user = "${username}";
      group = "users";

      settings = {
        home = "/home/${username}/torrents";
        download-dir = "/home/${username}/torrents/complete";
        incomplete-dir = "/home/${username}/torrents/incomplete";
        watch-dir = "/home/${username}/torrents/watch";
      };
    };

    ollama = {
      enable = true;
      acceleration = "cuda";
    };

    open-webui.enable = true;
  };
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=poweroff
  '';
}

{
  ry.immich.nixos = {
    services.immich = {
      enable = true;
      host = "0.0.0.0";
      mediaLocation = "/storage/media/photos";
      openFirewall = true;
    };

    systemd.tmpfiles.settings.immich-media."/storage/media/photos".d = {
      user = "immich";
      group = "immich";
      mode = "0700";
    };
  };
}

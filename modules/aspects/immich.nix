_: {
  ry.immich.nixos = _: {
    services.immich = {
      enable = true;
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

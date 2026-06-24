{config, ...}: {
  services.qui = {
    enable = true;
    secretFile = config.age.secrets.qui.path;
    settings.host = "0.0.0.0";
  };

  # qui needs to write the cross-seed hardlink tree under /storage/Torrents,
  # which is group-writable only by `media`.
  users.users.qui.extraGroups = ["media"];
}

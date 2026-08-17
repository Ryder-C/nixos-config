{
  config,
  lib,
  ...
}: {
  services.qui = {
    enable = true;
    secretFile = config.age.secrets.qui.path;
    settings.host = "0.0.0.0";
  };

  # qui needs to write the cross-seed hardlink tree under /storage/Torrents,
  # which is group-writable only by `media`.
  users.users.qui.extraGroups = ["media"];

  # qui hardlinks files it doesn't own into the cross-seed tree, which
  # fs.protected_hardlinks=1 forbids without CAP_FOWNER. PrivateUsers must go
  # too: in a user namespace CAP_FOWNER only covers mapped uids.
  systemd.services.qui.serviceConfig = {
    PrivateUsers = lib.mkForce false;
    CapabilityBoundingSet = lib.mkForce ["CAP_FOWNER"];
    AmbientCapabilities = ["CAP_FOWNER"];
  };
}

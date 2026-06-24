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

  # qui hardlinks source files it doesn't own (e.g. sonarr's 0644 library
  # files) into the cross-seed tree. Under fs.protected_hardlinks=1 the kernel
  # only permits hardlinking a file the caller owns or can write, unless it has
  # CAP_FOWNER. Grant it (same pattern as the old cross-seed service), and turn
  # off PrivateUsers so the capability applies to files owned by other uids
  # (under a user namespace CAP_FOWNER only covers mapped uids).
  systemd.services.qui.serviceConfig = {
    PrivateUsers = lib.mkForce false;
    CapabilityBoundingSet = lib.mkForce ["CAP_FOWNER"];
    AmbientCapabilities = ["CAP_FOWNER"];
  };
}

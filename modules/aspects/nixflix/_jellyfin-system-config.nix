# Disable nixflix's declarative Jellyfin system-config management.
#
# nixflix's `jellyfin-system-config` service POSTs the entire System/Configuration
# to Jellyfin on every activation (encoding, trickplay, branding, network, library,
# AND the plugin repository list), replacing whatever is there. That POST is what
# wipes plugin repositories added by hand in Dashboard -> Plugins -> Repositories.
#
# Disabling it hands all Jellyfin system settings back to the UI: they persist in
# Jellyfin's own state, and the `nixflix.jellyfin.{encoding,system,branding}` options
# stop being applied (they're inert from here on).
#
# `jellyfin-plugins` (installs the managed AniDB/Shoko plugins) is the only unit that
# depends on jellyfin-system-config, so we repoint its ordering at jellyfin-setup-wizard
# (what it was transitively after anyway) to keep plugin installs working.
{
  lib,
  config,
  ...
}: {
  systemd.services.jellyfin-system-config.enable = lib.mkForce false;

  systemd.services.jellyfin-plugins = {
    after = lib.mkForce (["jellyfin-setup-wizard.service"] ++ config.nixflix.serviceDependencies);
    requires = lib.mkForce (["jellyfin-setup-wizard.service"] ++ config.nixflix.serviceDependencies);
  };
}

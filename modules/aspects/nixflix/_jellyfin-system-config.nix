# Disable nixflix's declarative Jellyfin system-config management.
#
# Its jellyfin-system-config service POSTs the whole System/Configuration on every
# activation -- including the plugin repository list -- wiping repositories added
# by hand in the UI. Disabling it hands all Jellyfin system settings back to the
# UI, so the nixflix.jellyfin.{encoding,system,branding} options go inert.
#
# jellyfin-plugins was the only unit ordered after it, so repoint that at
# jellyfin-setup-wizard to keep plugin installs working.
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

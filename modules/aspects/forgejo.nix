# Disabled in fornax/default.nix; ready to re-enable.
{
  ry.forgejo.nixos = {
    ry.caddy.vhosts = {
      "ryder.rs".code = 3000;
      "adinack.dev".code = 3000;
    };

    services.forgejo = {
      enable = true;
      lfs.enable = true;

      settings = {
        service.DISABLE_REGISTRATION = true;
        server = {
          # DOMAIN = "code.ryder.rs";
          # ROOT_URL = "https://code.ryder.rs";
          HTTP_PORT = 3000;
        };
      };
    };
  };
}

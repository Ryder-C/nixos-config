{
  ry.vaultwarden.nixos = {config, ...}: {
    ry.caddy.vhosts."vault" = 8222;

    services.vaultwarden = {
      enable = true;
      environmentFile = config.age.secrets.vaultwarden.path;
      config = {
        ROCKET_PORT = 8222;
        DOMAIN = "https://vault.ryder.rs";
        SIGNUPS_ALLOWED = false;
        INVITATIONS_ALLOWED = true;
        SHOW_PASSWORD_HINT = false;
      };
    };

    age.secrets.vaultwarden = {
      file = ../../secrets/vaultwarden.age;
      owner = "vaultwarden";
      mode = "0400";
    };
  };
}

{
  ry.vaultwarden.nixos = {config, ...}: {
    services.caddy.virtualHosts."vault.ryder.rs".extraConfig = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN_RYDER}
      }
      @adminRemote {
        path /admin*
        not remote_ip private_ranges
      }
      respond @adminRemote 403
      reverse_proxy localhost:8222
    '';

    services.vaultwarden = {
      enable = true;
      environmentFile = config.age.secrets.vaultwarden.path;
      config = {
        ROCKET_ADDRESS = "0.0.0.0";
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

    ry.homepage.services."Security" = [
      {
        "Vaultwarden" = {
          href = "https://vault.ryder.rs";
          icon = "vaultwarden";
        };
      }
    ];
  };
}

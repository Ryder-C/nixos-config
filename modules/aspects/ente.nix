{
  ry.ente.nixos = {lib, ...}: {
    services.ente = {
      api = {
        enable = true;
        enableLocalDB = true;
        domain = "ente-api.ryder.rs";
        nginx.enable = false;
        settings = {
          http.port = 8085;
          storage.media = {
            provider = 0; # local filesystem
            localDisk.rootPath = "/storage/ente";
          };
          # Museum crashes with a nil viper panic if s3 config is missing entirely
          s3 = {
            are_local_buckets = true;
            b2-eu-cen = {
              key = "dummy";
              secret = "dummy";
              endpoint = "localhost:3200";
              region = "eu-central-2";
              bucket = "dummy";
            };
          };
        };
      };

      web = {
        enable = true;
        domains = {
          photos = "photos.ryder.rs";
          albums = "albums.ryder.rs";
          accounts = "accounts.ryder.rs";
          cast = "cast.ryder.rs";
        };
      };
    };

    # Ente web module creates nginx vhosts to serve static files.
    # Bind nginx to a local-only port so Caddy handles public TLS.
    services.nginx = {
      defaultListenAddresses = lib.mkForce ["127.0.0.1"];
      defaultHTTPListenPort = 3001;
      virtualHosts = let
        noSSL = {forceSSL = lib.mkForce false;};
      in {
        "photos.ryder.rs" = noSSL;
        "accounts.ryder.rs" = noSSL;
        "cast.ryder.rs" = noSSL;
      };
    };

    systemd.tmpfiles.rules = [
      "d /storage/ente 0750 museum museum -"
    ];
  };
}

{
  ry.ente.nixos = {lib, config, ...}: {
    services.ente = {
      api = {
        enable = true;
        enableLocalDB = true;
        domain = "api.photos.ryder.rs";
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
          key = {
            encryption._secret = config.age.secrets.ente-encryption-key.path;
            hash._secret = config.age.secrets.ente-hash-key.path;
          };
          jwt.secret._secret = config.age.secrets.ente-jwt-secret.path;
          internal.admins = [1580559962386438];
          internal.disable-registration = true;
          internal.hardcoded-ott.emails = [{_secret = config.age.secrets.ente-ott.path;}];
        };
      };

      web = {
        enable = true;
        domains = {
          photos = "photos.ryder.rs";
          albums = "albums.photos.ryder.rs";
          accounts = "accounts.photos.ryder.rs";
          cast = "cast.photos.ryder.rs";
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
        "photos.ryder.rs" = noSSL; # albums is a serverAlias on this vhost
        "accounts.photos.ryder.rs" = noSSL;
        "cast.photos.ryder.rs" = noSSL;
      };
    };

    age.secrets = {
      ente-encryption-key = {
        file = ../../secrets/ente-encryption-key.age;
        owner = "ente";
        mode = "0400";
      };
      ente-hash-key = {
        file = ../../secrets/ente-hash-key.age;
        owner = "ente";
        mode = "0400";
      };
      ente-jwt-secret = {
        file = ../../secrets/ente-jwt-secret.age;
        owner = "ente";
        mode = "0400";
      };
      ente-ott = {
        file = ../../secrets/ente-ott.age;
        owner = "ente";
        mode = "0400";
      };
    };

    systemd.tmpfiles.rules = [
      "d /storage/ente 0750 museum museum -"
    ];
  };
}

{
  ry.caddy.nixos = {
    config,
    pkgs,
    lib,
    ...
  }: let
    dnsSnippet = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
      }
    '';
  in {
    options.ry.caddy.vhosts = lib.mkOption {
      type = lib.types.attrsOf lib.types.port;
      default = {};
      description = "Map of subdomain to port";
    };

    config = {
      services.caddy = {
        enable = true;
        package = pkgs.caddy.withPlugins {
          plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
          hash = "sha256-Olz4W84Kiyldy+JtbIicVCL7dAYl4zq+2rxEOUTObxA=";
        };
        virtualHosts = lib.mapAttrs' (subdomain: port: lib.nameValuePair "${subdomain}.ryder.rs" {
          extraConfig = ''
            ${dnsSnippet}
            reverse_proxy localhost:${toString port}
          '';
        }) config.ry.caddy.vhosts;
      };

      age.secrets.cloudflare-api-token = {
        file = ../../secrets/cloudflare-api-token.age;
        owner = "caddy";
        mode = "0400";
      };

      systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.cloudflare-api-token.path;

      networking.firewall.allowedTCPPorts = [80 443];
    };
  };
}

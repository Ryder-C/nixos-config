{
  ry.caddy.nixos = {
    config,
    pkgs,
    lib,
    ...
  }: let
    domainTokens = {
      "ryder.rs" = "CF_API_TOKEN_RYDER";
      "adinack.dev" = "CF_API_TOKEN_ADIN";
    };
  in {
    options.ry.caddy.vhosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.port);
      default = {};
      description = "Map of subdomain to port";
    };

    config = {
      services.caddy = {
        enable = true;
        package = pkgs.caddy.withPlugins {
          plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
          hash = "sha256-8yZDrejNKsaUnUaTUFYbarWNmxafqp2z2rWo+XRsxV8=";
        };
        virtualHosts = lib.concatMapAttrs (domain: subdomains:
          lib.mapAttrs' (subdomain: port:
            lib.nameValuePair "${subdomain}.${domain}" {
              extraConfig = ''
                tls {
                  dns cloudflare {env.${domainTokens.${domain}}}
                }
                reverse_proxy localhost:${toString port}
              '';
            })
          subdomains)
        config.ry.caddy.vhosts;
      };

      age.secrets.cloudflare-api-token = {
        file = ../../secrets/cloudflare-api-token.age;
        owner = "caddy";
        mode = "0400";
      };

      systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.cloudflare-api-token.path;

      networking.firewall.allowedTCPPorts = [80 443];

      ry.homepage.services."Security" = [
        {
          "Caddy" = {
            icon = "caddy";
            widget = {
              type = "caddy";
              url = "http://localhost:2019";
            };
          };
        }
      ];
    };
  };
}

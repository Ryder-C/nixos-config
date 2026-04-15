{
  ry.caddy.nixos = {
    config,
    pkgs,
    ...
  }: let
    dnsSnippet = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
      }
    '';
  in {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
        hash = "sha256-Olz4W84Kiyldy+JtbIicVCL7dAYl4zq+2rxEOUTObxA=";
      };
      virtualHosts = {
        "media.ryder.rs".extraConfig = ''
          ${dnsSnippet}
          reverse_proxy localhost:8096
        '';

        # Ente static web apps
        # "photos.ryder.rs".extraConfig = ''
        #   ${dnsSnippet}
        #   reverse_proxy localhost:3001
        # '';
        # "albums.photos.ryder.rs".extraConfig = ''
        #   ${dnsSnippet}
        #   reverse_proxy localhost:3001
        # '';
        # "accounts.photos.ryder.rs".extraConfig = ''
        #   ${dnsSnippet}
        #   reverse_proxy localhost:3001
        # '';
        # "cast.photos.ryder.rs".extraConfig = ''
        #   ${dnsSnippet}
        #   reverse_proxy localhost:3001
        # '';

        # Ente API
        # "api.photos.ryder.rs".extraConfig = ''
        #   ${dnsSnippet}
        #   reverse_proxy localhost:8085
        # '';
      };
    };

    age.secrets.cloudflare-api-token = {
      file = ../../secrets/cloudflare-api-token.age;
      owner = "caddy";
      mode = "0400";
    };

    systemd.services.caddy.serviceConfig.EnvironmentFile = config.age.secrets.cloudflare-api-token.path;

    networking.firewall.allowedTCPPorts = [80 443];
  };
}

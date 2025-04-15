{username, ...}: {
  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    fstrim.enable = true;
    flatpak.enable = true;

    hardware.openrgb.enable = true;

    # pia-vpn = {
    #   enable = true;
    #   certificateFile = ../../ca.rsa.4096.crt;
    #   region = "ca_vancouver";
    #   environmentFile = config.age.secrets.pia.path;
    #
    #   portForward = {
    #     enable = true;
    #     script = ''
    #       export $(cat transmission-rpc.env | xargs)
    #       ${pkgs.transmission_4-qt}/bin/transmission-remote --authenv --port $port || true
    #     '';
    #   };
    # };

    transmission = {
      enable = true;
      user = "${username}";
      group = "users";

      settings = {
        home = "/home/${username}/torrents";
        download-dir = "/home/${username}/torrents/complete";
        incomplete-dir = "/home/${username}/torrents/incomplete";
        watch-dir = "/home/${username}/torrents/watch";
      };
    };

    ollama = {
      enable = true;
      acceleration = "cuda";
    };
    open-webui.enable = true;

    crab-hole = {
      enable = true;
      settings = {
        blocklist = {
          include_subdomains = true;
          lists = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts"
            "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
          ];
        };

        downstream = [
          {
            protocol = "udp"; # Standard DNS protocol
            listen = "127.0.0.1"; # Listen on IPv4 localhost
            port = 53;
          }
          {
            protocol = "udp";
            listen = "::1"; # Listen on IPv6 localhost
            port = 53;
          }
          # # TCP is also used for DNS sometimes, especially for larger replies
          # {
          #   protocol = "tcp";
          #   listen = "127.0.0.1";
          #   port = 53;
          # }
          # {
          #   protocol = "tcp";
          #   listen = "::1";
          #   port = 53;
          # }
        ];

        upstream = {
          name_servers = [
            {
              socket_addr = "1.1.1.1:853";
              protocol = "tls";
              tls_dns_name = "1dot1dot1dot1.cloudflare-dns.com";
              trust_nx_responses = false; # Recommended for privacy
            }
            {
              socket_addr = "[2606:4700:4700::1111]:853";
              protocol = "tls";
              tls_dns_name = "1dot1dot1dot1.cloudflare-dns.com";
              trust_nx_responses = false;
            }
          ];
          # Optional: Enable DNSSEC validation if your upstream supports it well.
          # Note the potential issue mentioned in the manual with hickory-dns
          # and non-DNSSEC domains if validation is strict.
          # options = {validate = true;};
        };
      };
    };
  };
}

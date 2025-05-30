{
  username,
  config,
  pkgs,
  inputs,
  ...
}: let
  qbtConfig = pkgs.writeText "qb-config" ''
    [BitTorrent]
    Session\DefaultSavePath=/home/${username}/Downloads
    Session\Interface=wg0
    Session\InterfaceName=wg0

    [Core]
    AutoDeleteAddedTorrentFile=IfAdded

    [LegalNotice]
    Accepted=true

    [Preferences]
    General\Locale=en
    WebUI\LocalHostAuth=false
    WebUI\Password_PBKDF2="@ByteArray(j4+5SCWf/tQzuaO6WYBu6A==:JSufcib2gxnil8o6KysPWMxQQ9wr2KYtwh5Fn0CrTs688o70InrEX89mfmmZgiAe5glgHLiahw7AyDgMhGkNng==)"

  '';
  profileBase = "/var/lib/qbittorrent";
  profName = "vpn";
in {
  imports = [inputs.nix-pia-vpn.nixosModules.default];

  systemd = {
    tmpfiles.rules = [
      "d ${profileBase} 0755 root root - -"
    ];
    services."home-manager-${username}".after = ["pia-vpn.service"];
    network = {
      # networks."wg0" = {
      #   matchConfig.Name = "wg0";
      #   linkConfig.RequiredForOnline = "no";
      # };
      # wait-online.ignoredInterfaces = ["wg0"];
      wait-online.anyInterface = true;
    };
  };

  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    fstrim.enable = true;
    flatpak.enable = true;

    hardware.openrgb.enable = true;

    pia-vpn = {
      enable = false;
      certificateFile = ../../ca.rsa.4096.crt;
      region = "ca_vancouver";
      environmentFile = config.age.secrets.pia.path;

      portForward = {
        enable = true;
        script = ''
          mkdir -p ${profileBase}/qBittorrent_${profName}
          cp ${qbtConfig} ${profileBase}/qBittorrent_${profName}/qBittorrent.conf
          ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --torrenting-port=$port --profile=${profileBase} --configuration=${profName} || true
        '';
      };
    };

    # transmission = {
    #   enable = false;
    #   # credentialsFile = config.age.secrets.transmission-rpc.path;
    #   user = "${username}";
    #   group = "users";
    #
    #   # settings = {
    #   #   home = "/home/${username}/torrents";
    #   # };
    # };

    ollama = {
      enable = false;
      acceleration = "cuda";
    };
    open-webui.enable = false;

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

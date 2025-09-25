{
  username,
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  chownScript = pkgs.writeShellScript "qbt-chown" ''
    #!${pkgs.runtimeShell}
    ${pkgs.coreutils}/bin/chown -R ${username}:users "$1"
  '';
  qbtConfig = pkgs.writeText "qb-config" ''
    [BitTorrent]
    Session\DefaultSavePath=/home/${username}/Torrents
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
    Downloads\OnFinish\Enabled=true
    Downloads\OnFinish\Program=${chownScript} "%F"
  '';
  profileBase = "/var/lib/qbittorrent";
  profName = "vpn";
in {
  imports = [inputs.nix-pia-vpn.nixosModules.default];

  systemd = {
    tmpfiles.rules = [
      "d ${profileBase} 0755 root root - -"
    ];
    services = {
      "home-manager-${username}".after = ["pia-vpn.service"];
      pia-vpn = {
        enable = true;
        # Ensure PIA waits for the network to be ready
        wants = [
          "network-online.target"
          "NetworkManager-wait-online.service"
          "systemd-resolved.service"
        ];
        after = [
          "network-online.target"
          "NetworkManager-wait-online.service"
          "systemd-resolved.service"
        ];
        # Extra guard: wait for connectivity and working DNS for target host
        serviceConfig = {
          ExecStartPre = pkgs.writeShellScript "pia-wait-dns" ''
            #!${pkgs.runtimeShell}
            # Probe DNS resolution for the PIA serverlist; try up to 15s
            for i in $(seq 1 15); do
              ${pkgs.systemd}/bin/resolvectl query serverlist.piaservers.net >/dev/null 2>&1 && exit 0
              ${pkgs.coreutils}/bin/sleep 1
            done
            exit 0
          '';
          # Restart = "on-failure";
          # RestartSec = "5s";
          # StartLimitBurst = 10;
        };
      };
      systemd-networkd-wait-online.enable = lib.mkForce false;
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    fstrim.enable = true;
    flatpak.enable = true;

    hardware.openrgb.enable = true;

    pia-vpn = {
      enable = true;
      certificateFile = ../../ca.rsa.4096.crt;
      region = "ca_vancouver";
      environmentFile = config.age.secrets.pia.path;

      portForward = {
        enable = true;
        script = ''
          mkdir -p ${profileBase}/qBittorrent_${profName}
          cp ${qbtConfig} ${profileBase}/qBittorrent_${profName}/qBittorrent.conf
          ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --confirm-legal-notice --torrenting-port=$port --profile=${profileBase} --configuration=${profName} || true
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

    # crab-hole removed per user request
  };
}

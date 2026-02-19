{
  username,
  config,
  pkgs,
  inputs,
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
  piaCertPath = "/etc/pia/ca.rsa.4096.crt";
in {
  imports = [inputs.nix-pia-vpn.nixosModules.default];

  environment.etc."pia/ca.rsa.4096.crt" = {
    source = ../../ca.rsa.4096.crt;
    mode = "0444";
  };

  systemd = {
    tmpfiles.rules = [
      "d ${profileBase} 0755 root root - -"
    ];
    services.pia-vpn = {
      enable = true;
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
      serviceConfig = {
        ExecStartPre = pkgs.writeShellScript "pia-wait-dns" ''
          #!${pkgs.runtimeShell}
          for i in $(seq 1 15); do
            ${pkgs.systemd}/bin/resolvectl query serverlist.piaservers.net >/dev/null 2>&1 && exit 0
            ${pkgs.coreutils}/bin/sleep 1
          done
          exit 0
        '';
        Restart = "on-failure";
        RestartSec = "5s";
        StartLimitBurst = 10;
      };
    };
  };

  services.pia-vpn = {
    enable = true;
    certificateFile = piaCertPath;
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
}

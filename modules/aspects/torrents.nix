{inputs, ...}: {
  flake-file.inputs.nix-pia-vpn = {
    url = "github:rcambrj/nix-pia-vpn";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.torrents.nixos = {
    pkgs,
    config,
    lib,
    ...
  }: let
    hasCrossSeed = config.age.secrets ? cross-seed;
    crossSeedWebhook =
      if hasCrossSeed
      then
        pkgs.writeShellScript "cross-seed-webhook" ''
          API_KEY=$(${pkgs.jq}/bin/jq -r '.apiKey' ${config.age.secrets.cross-seed.path})
          ${pkgs.curl}/bin/curl -XPOST "http://localhost:2468/api/webhook?apikey=$API_KEY" -d "infoHash=$1"
        ''
      else null;
    qbtConfig = pkgs.writeText "qb-config" ''
      [BitTorrent]
      Session\DefaultSavePath=/storage/Torrents
      Session\Interface=wg0
      Session\InterfaceName=wg0
      Session\AsyncIOThreadsCount=64
      Session\CoalesceReadWrite=true
      Session\DiskCacheSize=2048
      Session\DiskCacheTTL=60
      Session\DiskIOReadMode=DisableOSCache
      Session\DiskIOType=Default
      Session\DiskIOWriteMode=EnableOSCache
      Session\DiskQueueSize=67108864
      Session\PieceExtentAffinity=true
      Session\SendBufferLowWatermark=2048
      Session\SendBufferWatermark=8192
      Session\SendBufferWatermarkFactor=120
      Session\SuggestMode=true

      [Core]
      AutoDeleteAddedTorrentFile=IfAdded

      [LegalNotice]
      Accepted=true

      [Preferences]
      General\Locale=en
      WebUI\LocalHostAuth=false
      WebUI\Password_PBKDF2="@ByteArray(iCp/Z6bCKxlKKvdo2V83DA==:gl77/ciU/P+lQpul2KktZyuAj0ulk0lamAnsPSa4cjyD4fgojn
        +et4ctn1cOEa6ACbI+gSp/1+cw4OBbUiVtQtg==)"
      ${
        if hasCrossSeed
        then ''
          Downloads\OnFinish\Enabled=true
          Downloads\OnFinish\Program=${crossSeedWebhook} "%I"
        ''
        else ""
      }
    '';
    profileBase = "/var/lib/qbittorrent";
    profName = "vpn";
    piaCertPath = "/etc/pia/ca.rsa.4096.crt";
  in {
    imports = [inputs.nix-pia-vpn.nixosModules.default];

    age.secrets.pia = {
      file = ../../secrets/pia.age;
    };

    environment.etc."pia/ca.rsa.4096.crt" = {
      source = ../../ca.rsa.4096.crt;
      mode = "0444";
    };

    users.groups.media = {};

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

    services = {
      pia-vpn = {
        enable = true;
        certificateFile = piaCertPath;
        region = "ca_vancouver";
        environmentFile = config.age.secrets.pia.path;

        portForward = {
          enable = true;
          script = ''
            mkdir -p ${profileBase}/qBittorrent_${profName}
            rm -f ${profileBase}/qBittorrent_${profName}/qBittorrent.conf
            cp ${qbtConfig} ${profileBase}/qBittorrent_${profName}/qBittorrent.conf
            umask 0002
            ${pkgs.util-linux}/bin/runuser -u root -g media -- ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --confirm-legal-notice --torrenting-port=$port --profile=${profileBase} --configuration=${profName} || true
          '';
        };
      };
    };

    ry.homepage.services."Downloads" = [
      {
        "qBittorrent" = {
          href = "http://${config.networking.hostName}:8080";
          icon = "qbittorrent";
          widget = {
            type = "qbittorrent";
            url = "http://localhost:8080";
          };
        };
      }
    ];
  };
}

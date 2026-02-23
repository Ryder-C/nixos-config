{
  username,
  config,
  pkgs,
  inputs,
  stablePkgs,
  lib,
  host,
  ...
}: let
  isDesktop = host != "laptop";
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
  imports =
    [inputs.nix-pia-vpn.nixosModules.default]
    ++ lib.optionals isDesktop [./desktop-services.nix];

  environment.etc."pia/ca.rsa.4096.crt" = {
    source = ../../ca.rsa.4096.crt;
    mode = "0444";
  };

  systemd = lib.mkMerge [
    {
      user.services.niri-flake-polkit.enable = false;
      services.systemd-networkd-wait-online.enable = lib.mkForce false;
    }
    (lib.mkIf isDesktop {
      tmpfiles.rules = [
        "d ${profileBase} 0755 root root - -"
        "d /storage/models 0755 ollama ollama -"
      ];
      services = {
        pia-vpn = {
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
    })
  ];

  services = lib.mkMerge [
    {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
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
      tumbler.enable = true;
      gnome.gnome-keyring.enable = true;
      dbus.enable = true;
      fstrim.enable = true;
      flatpak.enable = true;
      seatd.enable = true;
      input-remapper.enable = true;
    }
    (lib.mkIf isDesktop {
      hardware.openrgb = {
        enable = true;
        motherboard = "amd";
        startupProfile = "main.orp";
      };

      pia-vpn = {
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

      ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
        user = "ollama";
        models = "/storage/models";
      };
      open-webui = {
        enable = true;
        port = 8081;

        environment = {
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
          WEBUI_AUTH = "False";
        };
      };
    })
  ];
}

{
  pkgs,
  stablePkgs,
  lib,
  host,
  ...
}: let
  isDesktop = host != "laptop";
in {
  imports = lib.optionals isDesktop [./desktop-services.nix];

  systemd = lib.mkMerge [
    {
      user.services.niri-flake-polkit.enable = false;
      services.systemd-networkd-wait-online.enable = lib.mkForce false;
    }
    (lib.mkIf isDesktop {
      tmpfiles.rules = [
        "d /storage/models 0755 ollama ollama -"
      ];
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

      ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
        user = "ollama";
        models = "/storage/models";
      };
      open-webui = {
        enable = true;
        port = 8081;
        package = stablePkgs.open-webui;
        environment = {
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
          WEBUI_AUTH = "False";
        };
      };
    })
  ];
}

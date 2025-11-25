{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [inputs.steam-presence.nixosModules.steam-presence];

  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia"; # optional; helps VA-API, harmless otherwise
    WLR_NO_HARDWARE_CURSORS = "1"; # keep this; cured your flicker
    __GL_VRR_ALLOWED = "0"; # keep VRR off in gamescope
  };

  programs = {
    steam = {
      enable = true;

      # remotePlay.openFirewall = true;

      protontricks.enable = true;

      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];

      presence = {
        enable = true;

        steamApiKeyFile = config.age.secrets.steam_key.path;
        userIds = ["76561198311078521"];
      };
    };

    gamescope = {
      enable = true;
      capSysNice = false; # Breaks gamescope when true
      args = [
        "--rt"
        "--xwayland-count 1"
        "--expose-wayland"
        #   # "--adaptive-sync"
        "--prefer-vk-device" # lspci -nn | grep VGA
        "10de:1e81" # Dedicated
      ];
    };
    gamemode = {
      enable = true;
      enableRenice = true;
    };
  };
  services.ananicy = {
    enable = true;
    extraRules = [
      {
        "name" = "gamescope";
        "nice" = -20;
      }
    ];
  };
}

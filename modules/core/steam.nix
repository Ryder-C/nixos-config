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

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;

      gamescopeSession = {
        enable = false;
        env = {
          WLR_RENDERER = "vulkan";
          WINE_FULLSCREEN_FSR = "1";
          # Games allegedly prefer X11
          # SDL_VIDEODRIVER = "x11";

          WLR_NO_HARDWARE_CURSORS = "1"; # NVIDIA cursor/flicker workaround
          __GL_VRR_ALLOWED = "0"; # belt-and-suspenders: disable driver-side VRR
        };
        args = [
          "--xwayland-count 1"
          "--expose-wayland"

          "-e" # Enable steam integration
          "--steam"

          # "--adaptive-sync"
          # "--hdr-enabled"
          # "--hdr-itm-enable"

          # External monitor
          # "--prefer-output HDMI-A-1"
          # "--output-width 2560"
          # "--output-height 1440"
          # "-r 75"

          # Laptop display
          # "--prefer-output eDP-1"
          # "--output-width 2560"
          # "--output-height 1600"
          # "-r 120"

          "--prefer-vk-device" # lspci -nn | grep VGA
          "10de:1e81" # Dedicated
          # 1002:1681 # Integrated
        ];
      };
      protontricks.enable = true;

      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];

      presence = {
        enable = true;
        # package = inputs.ryderpkgs.packages.${pkgs.system}.steam-presence;

        steamApiKeyFile = config.age.secrets.steam_key.path;
        userIds = ["76561198311078521"];
      };
    };

    steam.package = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };

    gamescope = {
      enable = true;
      capSysNice = true; # Breaks gamescope when true
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
  # services.ananicy = {
  #   enable = true;
  #   extraRules = [
  #     {
  #       "name" = "gamescope";
  #       "nice" = -20;
  #     }
  #   ];
  # };
}

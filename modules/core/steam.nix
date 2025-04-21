{
  pkgs,
  lib,
  ...
}: {
  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;

      gamescopeSession = {
        enable = true;
        env = {
          WLR_RENDERER = "vulkan";
          DXVK_HDR = "1";
          ENABLE_GAMESCOPE_WSI = "1";
          WINE_FULLSCREEN_FSR = "1";
          # Games allegedly prefer X11
          SDL_VIDEODRIVER = "x11";
        };
        args = [
          "--xwayland-count 2"
          "--expose-wayland"

          "-e" # Enable steam integration
          "--steam"

          "--adaptive-sync"
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
      capSysNice = false; # Breaks gamescope when true
      args = [
        "--rt"
        "--xwayland-count 2"
        "--expose-wayland"
        "--adaptive-sync"
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

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

      gamescopeSession.enable = true;
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
        # "--expose-wayland"
        "--adaptive-sync"
      ];
    };
    gamemode = {
      enable = true;
      enableRenice = true;
    };
  };
}

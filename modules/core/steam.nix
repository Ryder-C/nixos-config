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

    gamescope = {
      enable = true;
      capSysNice = true; # Breaks gamescope when true
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
    gamemode = {
      enable = true;
      enableRenice = true;
    };
  };
}

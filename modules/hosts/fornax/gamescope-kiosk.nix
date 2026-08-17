{ry, ...}: {
  # Headless 4K gamescope session for game streaming.
  den.aspects.fornax = {
    includes = [ry.steam];

    nixos.programs.steam.gamescopeSession = {
      enable = true;
      args = [
        "-W 3840"
        "-H 2160"
        "-w 3840"
        "-h 2160"
        "-r 60"
        "-o 60"
        "--force-grab-cursor"
      ];
    };
  };
}

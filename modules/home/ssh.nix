{lib, ...}:
with lib; {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "plex-server" = {
        hostname = "64.98.193.48";
        identityFile = "~/.ssh/plex_server";
        identitiesOnly = true;
        user = "evan";
      };
      "cutlass" = {
        hostname = "cutlass.adinack.dev";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        user = "ryder";
      };
    };
  };
}

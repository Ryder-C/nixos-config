{lib, ...}:
with lib; {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "plex-server" = {
        hostname = "64.98.193.48";
        identityFile = "~/.ssh/plex_server";
        identitiesOnly = true;
        user = "evan";
      };
      "cutlass" = {
        hostname = "2601:647:4800:ed90:1a66:daff:fe9c:ef14";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        user = "ryder";
      };
    };
  };
}

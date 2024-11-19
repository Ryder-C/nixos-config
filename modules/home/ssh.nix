{lib, ...}:
with lib; {
  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    "plex-server" = {
      hostname = "64.98.193.48";
      identityFile = "~/.ssh/plex_server";
      identitiesOnly = true;
      user = "evan";
    };
  };
}

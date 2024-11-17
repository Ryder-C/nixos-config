{ lib, ... }: with lib; {
  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    "plex-server" = {
      identityFile = "~/.ssh/plex_server";
      identitiesOnly = true;
      user = "evan";
    };
  };
}

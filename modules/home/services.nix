{
  inputs,
  pkgs,
  ...
}: {
  services = {
    cliphist = {
      enable = true;
      allowImages = true;
    };
    playerctld.enable = true;
    activitywatch = {
      enable = true;
      watchers = {
        awatcher = {
          package = pkgs.awatcher;
        };
        aw-watcher-media-player = {
          package = inputs.rypkgs.packages.${pkgs.stdenv.hostPlatform.system}.aw-watcher-media-player;
        };
      };
    };
  };
}

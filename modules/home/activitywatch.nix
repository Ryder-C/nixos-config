{inputs, pkgs, ...}: {
  services.activitywatch = {
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
}

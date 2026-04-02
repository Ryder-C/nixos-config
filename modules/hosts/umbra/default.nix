{ry, ...}: {
  den.aspects.umbra = {
    includes = [
      ry.terminal
      ry.shell
      ry.editor
      ry.development
      ry.packages
      ry.media-apps
    ];

    darwin = {
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = ["nix-command" "flakes"];
    };
  };
}

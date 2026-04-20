{ry, ...}: {
  den.aspects.umbra = {
    includes = [ry.base-darwin];

    darwin = {
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = ["nix-command" "flakes"];
    };
  };
}

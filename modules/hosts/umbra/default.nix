{ry, ...}: {
  den.aspects.umbra = {
    includes = [
      ry.terminal
      ry.shell
      ry.editor
      ry.development
      ry.packages
      ry.media-apps
      ry.browser
      ry.catppuccin
    ];

    darwin = {
      nix.settings.experimental-features = ["nix-command" "flakes"];
      nixpkgs.config.allowUnfree = true;
    };
  };
}

{inputs, ...}: {
  imports = [inputs.aagl.nixosModules.default];
  nix.settings = inputs.aagl.nixConfig;
  programs.anime-game-launcher = {
    enable = true;
    package = inputs.aagl.packages.x86_64-linux.anime-game-launcher;
  };
}

{aagl}: {
  imports = [aagl.nixosModules.default];
  nix.settings = aagl.nixConfig;
  programs.anime-game-launcher.enable = true;
  programs.anime-games-launcher.enable = true;
}

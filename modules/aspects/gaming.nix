{
  # Gaming HM packages (all hosts)
  ry.gaming.homeManager = {
    pkgs,
    stablePkgs,
    ...
  }: {
    home.packages = with pkgs; [
      osu-lazer
      heroic

      ## Minecraft
      stablePkgs.prismlauncher
      libxkbcommon

      ## Cli games
      vitetris
      nethack
    ];
  };
}

{
  pkgs,
  stablePkgs,
  ...
}: {
  home.packages = with pkgs; [
    winetricks
    mangohud

    ## Minecraft
    stablePkgs.prismlauncher
    waywall
    glfw3-minecraft
    libxkbcommon

    ## Cli games
    vitetris
    nethack

    stablePkgs.lutris
  ];
}

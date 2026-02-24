{
  pkgs,
  stablePkgs,
  host,
  lib,
  ...
}: {
  home.packages = lib.mkIf (host != "laptop") (with pkgs; [
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
  ]);
}

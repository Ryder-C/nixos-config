{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    brave
    google-chrome
  ];

  programs.librewolf.enable = true;

  home.sessionVariables = {
    BROWSER = "brave";
  };
}

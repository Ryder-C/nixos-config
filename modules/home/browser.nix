{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    brave
    google-chrome
  ];
  home.sessionVariables = {
    BROWSER = "zen";
  };
}

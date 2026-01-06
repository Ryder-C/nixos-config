{
  inputs,
  pkgs,
  stablePkgs,
  ...
}:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    equibop.enable = true;
    # vesktop.enable = true;
    # vesktop.package = stablePkgs.vesktop;
    config = {
      themeLinks = [
        "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"
      ];
      plugins = {
        gameActivityToggle.enable = true;
        silentTyping.enable = true;
        typingIndicator.enable = true;
        shikiCodeblocks.enable = true;
      };
    };
  };
}

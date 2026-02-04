{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nixcord.homeModules.nixcord];

  programs.nixcord = {
    enable = true;
    equibop.enable = false;
    vesktop.enable = true;
    config = {
      enabledThemes = [
        "catppuccin-mocha.theme.css"
      ];
      plugins = {
        gameActivityToggle.enable = true;
        silentTyping.enable = true;
        typingIndicator.enable = true;
        shikiCodeblocks.enable = true;
      };
    };
  };

  xdg.configFile."vesktop/themes/catppuccin-mocha.theme.css".source = pkgs.fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    hash = "sha256-X1AaGVWr/4Ye/8MMViT70d97Eq0ZOLmvumtOG7tiZ+Y=";
  };
}

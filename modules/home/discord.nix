{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nixcord.homeModules.nixcord];

  programs.nixcord = {
    enable = true;
    discord.enable = false;
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
    hash = "sha256-KVv9vfqI+WADn3w4yE1eNsmtm7PQq9ugKiSL3EOLheI=";
  };
}

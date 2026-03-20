{inputs, ...}: {
  flake-file.inputs = {
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    discord-catppuccin = {
      url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
      flake = false;
    };
  };

  ry.discord.homeManager = {pkgs, ...}: let
    catppuccinTheme = inputs.discord-catppuccin;
  in {
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
          webScreenShareFixes.enable = true;
        };
      };
    };

    xdg.configFile = {
      "vesktop/themes/catppuccin-mocha.theme.css".source = catppuccinTheme;
      "equibop/themes/catppuccin-mocha.theme.css".source = catppuccinTheme;
      "dorion/themes/catppuccin-mocha.theme.css".source = catppuccinTheme;
    };
  };
}

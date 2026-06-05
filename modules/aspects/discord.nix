{inputs, ...}: {
  flake-file.inputs = {
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  ry.discord.homeManager = {pkgs, ...}: {
    imports = [inputs.nixcord.homeModules.nixcord];

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];
      config.niri = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
        "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
      };
    };

    programs.nixcord = {
      enable = true;

      discord = {
        enable = true;
        vencord.enable = true;
      };
      equibop.enable = false;
      vesktop.enable = false;

      config = {
        themeLinks = [
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"
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
  };
}

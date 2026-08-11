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
      extraPortals = [pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk];
      config.niri = {
        default = ["gtk"];
        # niri implements screencast via org.gnome.Mutter.ScreenCast, so it must
        # be routed to xdp-gnome. xdp-wlr's screencopy path has no damage
        # tracking here, which niri treats as a one-off screenshot -> the
        # screenshare freezes on its first frame.
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
      };
    };

    programs = {
      nixcord = {
        enable = true;

        discord = {
          enable = true;
          vencord.enable = false;
          equicord.enable = true;
        };
        equibop.enable = false;
        vesktop.enable = false;

        config = {
          enabledThemeLinks = [
            "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"
          ];
          frameless = true;
          plugins = {
            gameActivityToggle.enable = true;
            silentTyping.enable = true;
            typingIndicator.enable = true;
            shikiCodeblocks.enable = true;
            declutter.enable = true;
            ghosted.enable = true;
            fakeNitro.enable = true;
          };
        };
      };
    };
  };
}

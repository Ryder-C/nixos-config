{pkgs, ...}: {
  fonts.fontconfig = {
    enable = true;

    defaultFonts.monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
  };
  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.noto
    pkgs.twemoji-color-font
    pkgs.noto-fonts-color-emoji
    pkgs.dracula-theme
    pkgs.dracula-icon-theme
    pkgs.adwaita-icon-theme
  ];

  catppuccin = {
    # gtk = {
    #   enable = true;
    #   icon = {
    #     enable = true;
    #     accent = "lavender";
    #   };
    # };
    cursors = {
      enable = true;
      accent = "dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    # iconTheme = {
    #   name = "Dracula";
    #   package = pkgs.dracula-icon-theme;
    # };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
  };
}

{inputs, ...}: {
  flake-file.inputs.nix-yazi-plugins = {
    url = "github:lordkekz/nix-yazi-plugins";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.media-apps.homeManager = {
    pkgs,
    ...
  }: {
    imports = [
      inputs.nix-yazi-plugins.legacyPackages.x86_64-linux.homeManagerModules.default
    ];

    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.noto
      twemoji-color-font
      noto-fonts-color-emoji
      dracula-theme
      dracula-icon-theme
      adwaita-icon-theme
    ];

    programs = {
      bat = {
        enable = true;
        config.pager = "less -FR";
      };

      btop = {
        enable = true;
        package = pkgs.btop;
        settings = {
          theme_background = false;
          update_ms = 500;
        };
      };

      cava.enable = true;

      yazi = {
        enable = true;
        shellWrapperName = "y";
        plugins = with pkgs.yaziPlugins; {inherit yatline-catppuccin rich-preview;};
        settings = {
          opener.edit = [
            {
              run = "nvim \"$@\"";
              block = true;
              for = "unix";
            }
          ];
        };
        yaziPlugins = {
          enable = true;
          plugins = {
            starship.enable = true;
            jump-to-char = {
              enable = true;
              keys.toggle.on = ["F"];
            };
            bookmarks.enable = true;
          };
        };
      };
    };

    catppuccin = {
      cava.transparent = true;
      cursors = {
        enable = true;
        accent = "dark";
      };
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
    };

    gtk = {
      enable = true;
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 11;
      };
    };
  };
}

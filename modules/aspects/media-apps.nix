{inputs, ...}: {
  flake-file.inputs.nix-yazi-plugins = {
    url = "github:lordkekz/nix-yazi-plugins";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.media-apps = {
    nixos = {pkgs, ...}: {
      home-manager.sharedModules = [
        inputs.nix-yazi-plugins.legacyPackages.${pkgs.stdenv.hostPlatform.system}.homeManagerModules.default
      ];
    };
    darwin = {pkgs, ...}: {
      home-manager.sharedModules = [
        inputs.nix-yazi-plugins.legacyPackages.${pkgs.stdenv.hostPlatform.system}.homeManagerModules.default
      ];
    };
  };

  ry.media-apps.homeManager = {
    pkgs,
    lib,
    isLinux,
    config,
    ...
  }: {
    home.packages = with pkgs;
      [
        nerd-fonts.fira-code
        nerd-fonts.noto
        twemoji-color-font
        noto-fonts-color-emoji
      ]
      ++ lib.optionals isLinux [
        dracula-theme
        dracula-icon-theme
        adwaita-icon-theme
      ];

    programs = {
      btop = {
        enable = true;
        package = pkgs.btop;
        settings = {
          theme_background = false;
          update_ms = 500;
        };
      };

      cava.enable = isLinux;

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

    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = ["FiraCode Nerd Font" "Noto Color Emoji"];
    };

    gtk = lib.mkIf isLinux {
      enable = true;
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
      # HM changed the gtk4 theme default to null; keep theming GTK4 apps.
      gtk4.theme = config.gtk.theme;
      font = {
        name = "FiraCode Nerd Font";
        size = 11;
      };
    };
  };
}

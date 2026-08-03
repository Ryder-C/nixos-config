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
  }: let
    # nixpkgs removed every murrine-based GTK theme on 2026-07-22, including
    # magnetic-catppuccin-gtk. murrine was only a GTK2 runtime dep, so build it
    # here without it.
    catppuccin-gtk = pkgs.stdenvNoCC.mkDerivation {
      pname = "catppuccin-gtk-theme";
      version = "0-unstable-2026-06-25";

      src = pkgs.fetchFromGitHub {
        owner = "Fausto-Korpsvart";
        repo = "Catppuccin-GTK-Theme";
        rev = "a0f69cc33299dc97267c3507fe8a001aecc46b0f";
        hash = "sha256-bSEWm62EWHC9zcYA+YoQp2cuSFt2FDsjalapnjYdoYU=";
      };

      nativeBuildInputs = with pkgs; [jdupes sassc];

      postPatch = "patchShebangs themes";

      dontBuild = true;

      # BATCH_MODE skips the installer's interactive "apply now?" prompt, and the
      # long accent flag is --theme despite what --help claims.
      installPhase = ''
        runHook preInstall
        export HOME=$TMPDIR
        mkdir -p $out/share/themes
        BATCH_MODE=true ./themes/install.sh \
          --name Catppuccin \
          --theme mauve \
          --mode dark \
          --size standard \
          --dest $out/share/themes
        jdupes --quiet --link-soft --recurse $out/share
        runHook postInstall
      '';
    };
  in {
    home.packages = with pkgs;
      [
        nerd-fonts.fira-code
        nerd-fonts.noto
        twemoji-color-font
        noto-fonts-color-emoji
      ]
      ++ lib.optionals isLinux [
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
        name = "Catppuccin-Mauve-Dark";
        package = catppuccin-gtk;
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

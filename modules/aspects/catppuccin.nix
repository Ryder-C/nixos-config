{inputs, ...}: {
  flake-file.inputs = {
    catppuccin-stylus-json = {
      url = "https://github.com/catppuccin/userstyles/releases/download/all-userstyles-export/import.json";
      flake = false;
    };
  };

  ry.catppuccin = {
    homeManager = {pkgs, ...}: {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      catppuccin = {
        enable = true;
        cache.enable = true;
        accent = "mauve";
        flavor = "mocha";
        cava.transparent = true;
        cursors = {
          enable = true;
          accent = "dark";
        };
      };

      # Symlink the Catppuccin Stylus JSON (patched to keep YouTube video backgrounds black)
      home.file."catppuccin_styles.json".source =
        pkgs.runCommand "catppuccin-stylus-patched.json" {
          nativeBuildInputs = [pkgs.jq];
        } ''
          jq '
            map(
              if .name == "YouTube Catppuccin" then
                .sourceCode += "\n/* Override: keep video letterbox bars black */\nvideo, video::backdrop, .html5-video-player, .html5-video-container { background-color: #000 !important; }\n"
              else . end
            )
          ' ${inputs.catppuccin-stylus-json} > $out
        '';

      # Ensure terminal applications use Neovim by default
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  };
}

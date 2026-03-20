{inputs, ...}: {
  flake-file.inputs = {
    catppuccin-stylus-json = {
      url = "https://github.com/catppuccin/userstyles/releases/download/all-userstyles-export/import.json";
      flake = false;
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  ry.catppuccin = {
    homeManager = {pkgs, ...}: {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
        inputs.nix-index-database.homeModules.nix-index
      ];

      catppuccin = {
        enable = true;
        cache.enable = true;
        accent = "mauve";
        flavor = "mocha";
        cursors.enable = true;
      };

      # Symlink the Catppuccin Stylus JSON (patched to keep YouTube video backgrounds black)
      home.file."catppuccin_styles.json".source = pkgs.runCommand "catppuccin-stylus-patched.json" {
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

      # nix-index with comma - run any command without installing
      programs.nix-index-database.comma.enable = true;
    };
  };
}

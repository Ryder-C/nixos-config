{inputs, ...}: {
  flake-file.inputs = {
    alejandra.url = "github:kamadorueda/alejandra";
  };
  ry.development.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      gh
      git-lfs
      difftastic
      devenv
      vscode
      obs-studio
      mcp-nixos

      # Languages & toolchains
      nodejs
      (rust-bin.stable.latest.default.override {
        extensions = [
          "rust-src"
          "rustfmt"
          "clippy"
        ];
        targets = [
          (
            if pkgs.stdenv.hostPlatform.isAarch64
            then "aarch64-unknown-linux-gnu"
            else "x86_64-unknown-linux-gnu"
          )
        ];
      })
      rust-analyzer

      # GPU debugging
      mesa-demos
      vulkan-tools

      typst
      typstyle
      inputs.alejandra.defaultPackage.${pkgs.stdenv.hostPlatform.system}
      blender
    ];

    programs = {
      zed-editor.enable = true;
      claude-code = {
        enable = true;
        package = pkgs.claude-code;
      };
      gemini-cli = {
        enable = true;
        settings = {
          general = {
            preferredEditor = "nvim";
            previewFeatures = true;
          };
          experimental.plan = true;
        };
      };
      opencode.enable = true;
      direnv.enable = true;

      # Git
      jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Ryder Casazza";
            email = "rydercasazza@gmail.com";
          };
          ui = {
            default-command = ["log" "-r" "main::"];
            diff-formatter = ["difft" "--color=always" "$left" "$right"];
          };
          aliases = {
            sync = ["rebase" "-s" "((roots((((::trunk()):: ~ ::trunk()) & mutable())..(::trunk()))-)+ & mutable()) ~ ::trunk()" "-o" "trunk()"];
          };
        };
      };
      git = {
        enable = true;
        settings = {
          user = {
            name = "Ryder Casazza";
            email = "rydercasazza@gmail.com";
          };
          init.defaultBranch = "main";
          credential.helper = "store";
        };
      };
      lazygit = {
        enable = true;
        settings.gui = {
          theme = {
            activeBorderColor = ["#cba6f7" "bold"];
            inactiveBorderColor = ["#a6adc8"];
            optionsTextColor = ["#89b4fa"];
            selectedLineBgColor = ["#313244"];
            cherryPickedCommitBgColor = ["#45475a"];
            cherryPickedCommitFgColor = ["#cba6f7"];
            unstagedChangesColor = ["#f38ba8"];
            defaultFgColor = ["#cdd6f4"];
            searchingActiveBorderColor = ["#f9e2af"];
          };
          authorColors."*" = "#b4befe";
        };
      };

      # SSH
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "plex-server" = {
            hostname = "64.98.193.48";
            identityFile = "~/.ssh/plex_server";
            identitiesOnly = true;
            user = "evan";
          };
          "cutlass" = {
            hostname = "cutlass.adinack.dev";
            identityFile = "~/.ssh/id_ed25519";
            identitiesOnly = true;
            user = "ryder";
          };
        };
      };
    };
  };
}

{inputs, ...}: {
  flake-file.inputs = {
    alejandra.url = "github:kamadorueda/alejandra";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  ry.development.homeManager = {
    pkgs,
    stablePkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.nix-index-database.homeModules.nix-index
    ];

    home.packages = with pkgs; [
      gh
      ripgrep
      git-lfs
      difftastic
      devenv
      vscode
      obs-studio

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
      stablePkgs.blender
    ];

    programs = {
      nix-index-database.comma.enable = true;
      zed-editor.enable = true;
      mcp = {
        enable = true;
        servers = {
          nixos.command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
          "duckduckgo" = {
            command = lib.getExe' pkgs.uv "uvx";
            args = ["duckduckgo-mcp-server"];
          };
        };
      };
      claude-code = {
        enable = true;
        enableMcpIntegration = true;
        package = pkgs.claude-code;

        settings = {
          hooks = {
            Notification = [
              {
                matcher = "";
                hooks = [
                  {
                    type = "command";
                    command = "read data && echo \"$data\" | jq -e '.message | length > 0' > /dev/null && notify-send -u critical 'Claude Code' 'Needs your attention'";
                  }
                ];
              }
            ];
            Stop = [
              {
                matcher = "";
                hooks = [
                  {
                    type = "command";
                    command = "notify-send 'Claude Code' 'Task completed'";
                  }
                ];
              }
            ];
          };
        };
      };
      opencode = {
        enable = true;
        enableMcpIntegration = true;
      };
      gemini-cli = {
        enable = true;
        settings = {
          mcpServers = {
            nixos.command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
          };
          general = {
            sessionRetention = {
              enabled = true;
              maxAge = "30d";
              warningAcknowledged = true;
            };
            preferredEditor = "nvim";
            previewFeatures = true;
          };
          experimental.plan = true;
          security.auth.selectedType = "oauth-personal";
        };
      };
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

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
    isLinux,
    ...
  }: {
    imports = [
      inputs.nix-index-database.homeModules.nix-index
    ];

    home.packages = with pkgs;
      [
        gh
        ripgrep
        git-lfs
        difftastic
        devenv
        vscode
        nil
        kicad

        # Languages & toolchains
        nodejs

        typst
        typstyle
      ]
      ++ lib.optionals isLinux [
        inputs.alejandra.defaultPackage.${pkgs.stdenv.hostPlatform.system}
        obs-studio

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

        settings = lib.mkMerge [
          (lib.mkIf isLinux {
            preferredNotifChannel = "terminal_bell";
            statusLine = {
              type = "command";
              command = "bash /home/ryder/.claude/statusline-command.sh";
            };
          })
        ];
      };
      opencode = {
        enable = true;
        enableMcpIntegration = true;
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
            default-command = ["log" "-r" "trunk()::"];
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
    };

    home.file.".claude/statusline-command.sh" = lib.mkIf isLinux {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        # Claude Code status line — mirrors Starship Catppuccin Mocha prompt style

        input=$(cat)

        cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
        model=$(echo "$input" | jq -r '.model.display_name // empty')
        used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
        five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
        seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

        # Catppuccin Mocha colours (dimmed-friendly)
        blue='\033[38;2;137;180;250m'    # #89b4fa
        lavender='\033[38;2;180;190;254m' # #b4befe
        yellow='\033[38;2;249;226;175m'  # #f9e2af
        peach='\033[38;2;250;179;135m'   # #fab387
        reset='\033[0m'

        # Shorten home directory to ~
        if [ -n "$cwd" ]; then
            home="$HOME"
            short_cwd="''${cwd/#$home/~}"
        else
            short_cwd="?"
        fi

        parts=""

        # Directory segment (blue  icon + lavender path)
        parts="''${parts}$(printf "''${blue} ''${lavender}''${short_cwd}''${reset}")"

        # Model segment
        if [ -n "$model" ]; then
            parts="''${parts}  $(printf "''${blue}''${model}''${reset}")"
        fi

        # Context usage segment
        if [ -n "$used" ]; then
            used_int=$(printf '%.0f' "$used")
            parts="''${parts}  $(printf "''${yellow}ctx:''${used_int}%%''${reset}")"
        fi

        # Plan usage segments
        if [ -n "$five_hour" ]; then
            five_int=$(printf '%.0f' "$five_hour")
            parts="''${parts}  $(printf "''${peach}5h:''${five_int}%%''${reset}")"
        fi
        if [ -n "$seven_day" ]; then
            week_int=$(printf '%.0f' "$seven_day")
            parts="''${parts}  $(printf "''${peach}7d:''${week_int}%%''${reset}")"
        fi

        printf "%b" "$parts"
      '';
    };
  };
}

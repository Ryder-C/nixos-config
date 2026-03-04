{inputs, ...}: {
  flake-file.inputs.jj-starship = {
    url = "github:dmmulroy/jj-starship";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.shell.homeManager = {
    pkgs,
    osConfig,
    ...
  }: {
    home.packages = [
      inputs.jj-starship.packages.${pkgs.stdenv.hostPlatform.system}.jj-starship
    ];

    programs = {
      fish = {
        enable = true;

        shellInit = ''
          # Set environment variables
          set -gx EDITOR nvim
          set -gx VISUAL nvim
          set -gx FISH_CONFIG_FILE ~/.config/fish/config.fish
          set -gx fish_greeting ""
        '';

        functions = {
          cdnix = ''
            cd ~/nixos-config
            nvim
          '';

          nsu = ''
            nh os switch --hostname ${osConfig.networking.hostName} --update --impure $HOME/nixos-config?submodules=1
            nix-store --optimise
          '';

          gcma = ''
            git add --all
            git commit -m $argv
          '';

          y = ''
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            yazi $argv --cwd-file $tmp
            set cwd (cat $tmp)
            if test -n "$cwd" -a "$cwd" != "$PWD"
              cd $cwd
            end
            rm -f $tmp
          '';
        };

        shellAliases = {
          c = "clear";
          l = "ls";
          ll = "ls -l";
          cd = "z";
          tt = "gtrash put";
          cat = "bat";
          nano = "micro";
          py = "python";
          pdf = "tdf";
          open = "xdg-open";

          # Zellij
          za = "zellij attach (zellij ls | fzf --ansi | cut -d' ' -f1)";
          zj = "zellij -s (basename (pwd))";

          # Nixos
          nix-shell = "nix-shell --run fish";
          nix-clean = "nh clean all";
          ns = "nh os switch --hostname ${osConfig.networking.hostName} --impure $HOME/nixos-config?submodules=1";
          nst = "nh os test --hostname ${osConfig.networking.hostName} --impure $HOME/nixos-config?submodules=1";

          # Git
          ga = "git add";
          gaa = "git add --all";
          gs = "git status";
          gb = "git branch";
          gm = "git merge";
          gpl = "git pull";
          gplo = "git pull origin";
          gps = "git push";
          gpst = "git push --follow-tags";
          gpso = "git push origin";
          gc = "git commit";
          gcm = "git commit -m";
          gtag = "git tag -ma";
          gch = "git checkout";
          gchb = "git checkout -b";
          gcoe = "git config user.email";
          gcon = "git config user.name";

          # jj
          jjc = "jj commit";
          jje = "jj edit";
          jjd = "jj diff";
          jjds = "jj desc";
          jjl = "jj log";
          jjn = "jj new";
          jjgf = "jj git fetch";
          jjgp = "jj git push";
          jjbt = "jj bookmark track";
          jjbm = "jj bookmark move";
          jjbs = "jj bookmark set";
          jjsq = "jj squash";
        };

        plugins = with pkgs.fishPlugins; [
          {
            name = "fzf";
            inherit (fzf) src;
          }
        ];
      };

      carapace = {
        enable = true;
        enableFishIntegration = true;
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      zellij.settings.default_shell = "fish";
      yazi.enableFishIntegration = true;

      starship = {
        enable = true;
        settings = {
          directory = {
            format = "[ ](bold #89b4fa)[ $path ]($style)";
            style = "bold #b4befe";
          };
          character = {
            success_symbol = "[ ](bold #89b4fa)[ ➜](bold green)";
            error_symbol = "[ ](bold #89b4fa)[ ➜](bold red)";
          };
          cmd_duration = {
            format = "[󰔛 $duration]($style)";
            disabled = false;
            style = "bg:none fg:#f9e2af";
            show_notifications = false;
            min_time_to_notify = 60000;
          };
          custom.jj = {
            when = "jj-starship detect";
            command = "jj-starship";
            format = "$output ";
          };
          git_branch.disabled = true;
          git_commit.disabled = true;
          git_status.disabled = true;
        };
      };
    };
  };
}

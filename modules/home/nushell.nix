{host, ...}: {
  programs = {
    nushell = {
      enable = true;

      extraConfig = ''
        $env.config.buffer_editor = "nvim"
        $env.config.show_banner = false

        def cdnix [] {
          cd ~/nixos-config;
          nvim ~/nixos-config;
        }

        def ns [] {
          nix flake update nixvim --flake ($env.HOME | path join nixos-config);
          nh os switch --hostname ${host} ($env.HOME | path join nixos-config?submodules=1);
        }

        def nst [] {
          nix flake update nixvim --flake ($env.HOME | path join nixos-config);
          nh os switch --hostname desktop ($env.HOME | path join nixos-config?submodules=1);
        }

        def nsu [] {
          nh os switch --hostname ${host} --update ($env.HOME | path join nixos-config?submodules=1);
        }

        def gcma [message] {
          git add --all;
          git commit -m $message;
        }
      '';

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
        za = "zellij attach (zellij ls | fzf --ansi | split column ' ' | get column1 | get 0)";
        zj = "zellij -s (pwd | path basename)";

        # Nixos
        nix-shell = "nix-shell --run nu";
        nix-clean = "nh clean all";

        # Git ga = "git add";
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
      };
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
    zellij.settings.default_shell = "nu";
  };
}

{
  host,
  pkgs,
  ...
}: {
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
          nh os switch --hostname ${host} --update $HOME/nixos-config?submodules=1
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
        ns = "nh os switch --hostname ${host} $HOME/nixos-config?submodules=1";
        nst = "nh os test --hostname ${host} $HOME/nixos-config?submodules=1";

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
  };
}

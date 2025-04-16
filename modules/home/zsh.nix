{host, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "gh"
        "git-auto-fetch"
        "fzf"
        "rust"
        "tmux"
      ];
    };
    initExtraFirst = ''
      DISABLE_MAGIC_FUNCTIONS=true
      export "MICRO_TRUECOLOR=1"
      export PATH=$PATH:$HOME/.cargo/bin

      ZSH_TMUX_AUTONAME_SESSION=true
      ZSH_TMUX_UNICODE=true
    '';
    shellAliases = {
      # record = "wf-recorder --audio=alsa_output.pci-0000_08_00.6.analog-stereo.monitor -f $HOME/Videos/$(date +'%Y%m%d%H%M%S_1.mp4')";

      # Utils
      c = "clear";
      cd = "z";
      tt = "gtrash put";
      cat = "bat";
      nano = "micro";
      code = "codium";
      py = "python";
      icat = "kitten icat";
      dsize = "du -hs";
      findw = "grep -rl";
      pdf = "tdf";
      open = "xdg-open";

      l = "eza --icons  -a --group-directories-first -1"; # EZA_ICON_SPACING=2
      ll = "eza --icons  -a --group-directories-first -1 --no-user --long";
      tree = "eza --icons --tree --group-directories-first";

      # Nixos
      cdnix = "cd ~/nixos-config && nvim ~/nixos-config";
      nix-shell = "nix-shell --run zsh";
      ns = "nix flake update nixvim --flake $HOME/nixos-config && nh os switch --hostname ${host} \"$HOME/nixos-config?submodules=1\"";
      nst = "nix flake update nixvim --flake $HOME/nixos-config && nh os test --hostname ${host} \"$HOME/nixos-config?submodules=1\"";
      nsu = "nh os switch --hostname ${host} --update \"$HOME/nixos-config?submodules=1\"";
      nix-flake-update = "sudo nix flake update ~/nixos-config#";
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
      gcma = "git add --all && git commit -m";
      gtag = "git tag -ma";
      gch = "git checkout";
      gchb = "git checkout -b";
      gcoe = "git config user.email";
      gcon = "git config user.name";

      # python
      piv = "python -m venv .venv";
      psv = "source .venv/bin/activate";
    };
    initContent = ''
      precmd() {
        if [ -n "$TMUX" ]; then
          tmux select-pane -T "$(basename "$PWD")"
        fi
      }


      function sesh-sessions() {
        {
          exec </dev/tty
          exec <&1
          local session
          session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
          zle reset-prompt > /dev/null 2>&1 || true
          [[ -z "$session" ]] && return
          sesh connect $session
        }
      }

      zle     -N             sesh-sessions
      bindkey -M emacs '\es' sesh-sessions
      bindkey -M vicmd '\es' sesh-sessions
      bindkey -M viins '\es' sesh-sessions
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}

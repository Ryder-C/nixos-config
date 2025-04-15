{
  inputs,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;

    mouse = true;

    plugins = with pkgs; [
      # tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          # Configure the catppuccin plugin
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
        '';
      }
    ];

    keyMode = "vi";
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set-option -ga terminal-overrides ",*256col*:Tc,alacritty:Tc"

      # Renumber windows when one is closed
      set -g renumber-windows on

      # Set focus-events for better nvim-tmux integration
      set-option -g focus-events on

      # Make the status line pretty and add some modules
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -agF status-right "#{E:@catppuccin_status_cpu}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"

      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';
  };
}

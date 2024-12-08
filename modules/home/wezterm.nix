{
  inputs,
  pkgs,
  ...
}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    extraConfig = ''
      local config = {}

      config.color_scheme = "Catppuccin Mocha"
      config.window_background_opacity = 0.55
      config.font = wezterm.font("JetBrainsMono Nerd Font")
      config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

      config.hide_tab_bar_if_only_one_tab = true
      config.tab_bar_at_bottom = true
      config.window_frame = {
        active_titlebar_bg = '#1e1e2e',
        inactive_titlebar_bg = '#1e1e2e',
      }

      return config
    '';

    package = inputs.wezterm.packages.${pkgs.system}.default;
  };
}

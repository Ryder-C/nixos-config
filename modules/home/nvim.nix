{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  # home.file.".config/nvim".source = ../../nvim;
  # xdg.configFile."nvim" = {
  #   recursive = true;
  #   source = ../../nvim;
  # };
}

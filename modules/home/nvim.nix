{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];

  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    performance = {
      combinePlugins = {
        enable = true;
        standalonePlugins = [
          "hmts.nvim"
          "neorg"
          "nvim-treesitter"
        ];
      };
      byteCompileLua.enable = true;
    };

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
  };

  # programs.neovim = {
  #   enable = true;
  #   vimAlias = true;
  # };

  # home.file.".config/nvim".source = ../../nvim;
  # xdg.configFile."nvim" = {
  #   recursive = true;
  #   source = ../../nvim;
  # };
}

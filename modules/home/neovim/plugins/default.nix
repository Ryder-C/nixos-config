{pkgs, ...}: {
  imports = [
    ./barbar.nix
    ./comment.nix
    ./floaterm.nix
    ./harpoon.nix
    ./lsp.nix
    ./lualine.nix
    ./markdown-preview.nix
    ./neorg.nix
    ./neo-tree.nix
    ./startify.nix
    ./telescope.nix
    ./treesitter.nix
    ./vimtex.nix # inria
    ./leetcode.nix
    ./mini.nix
    ./conform.nix
  ];

  programs.nixvim = {
    extraPackages = with pkgs.vimPlugins; [
      plenary-nvim
      typst-preview-nvim
    ];

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    plugins = {
      web-devicons.enable = true;

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "+";
          change.text = "~";
        };
      };

      sleuth.enable = true;
      noice.enable = true;
      neocord.enable = true;
      which-key.enable = true;
      leap.enable = true;

      nvim-autopairs.enable = true;

      nvim-colorizer = {
        enable = true;
        userDefaultOptions.names = false;
      };

      oil.enable = false; # Replaced with mini.files

      trim = {
        enable = true;
        settings = {
          highlight = false;
          trim_on_write = true;
          ft_blocklist = [
            "checkhealth"
            "floaterm"
            "lspinfo"
            "neo-tree"
            "TelescopePrompt"
          ];
        };
      };
    };
  };
}

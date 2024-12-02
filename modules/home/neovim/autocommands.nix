{
  programs.nixvim.autoCmd = [
    # # Open NeoTree when entering
    # {
    #   event = "BufEnter";
    #   command = "Neotree";
    # }

    # Vertically center document when entering insert mode
    {
      event = "InsertEnter";
      command = "norm zz";
    }

    # Open help in a vertical split
    {
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }

    # Enable spellcheck for some filetypes
    {
      event = "FileType";
      pattern = [
        "tex" # inria
        "latex" # inria
        "markdown"
        "typ"
      ];
      command = "setlocal spell spelllang=en";
    }
  ];
}

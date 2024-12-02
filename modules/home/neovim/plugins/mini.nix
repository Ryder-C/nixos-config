{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>mf";
        action = ":lua MiniFiles.open()";
        options.silent = true;
      }
    ];

    plugins.mini = {
      enable = true;
      modules = {
        files = {};
      };
    };
  };
}

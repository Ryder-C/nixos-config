{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>fm";
        action = ":lua MiniFiles.open()<CR>";
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

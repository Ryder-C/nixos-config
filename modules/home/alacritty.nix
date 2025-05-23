{inputs, ...}: {
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        opacity = 0.8;

        padding = {
          x = 5;
          y = 5;
        };
      };

      terminal.shell = "nu";

      font.normal = {
        family = "monospace";
        style = "Regular";
      };
    };
  };
}

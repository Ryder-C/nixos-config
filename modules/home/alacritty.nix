{
  inputs,
  pkgs,
  ...
}: {
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

      font.normal = {
        family = "monospace";
        style = "Regular";
      };
    };
  };
}

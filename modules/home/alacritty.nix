{inputs, ...}: {
  programs.alacritty = {
    enable = true;

    settings = {
      general.import = ["${inputs.catppuccin-alacritty}/catppuccin-mocha.toml"];

      window = {
        opacity = 0.8;

        padding = {
          x = 5;
          y = 5;
        };
      };

      font.normal = {
        family = "JetBrainsMono Nerd Font";
        style = "Regular";
      };
    };
  };
}

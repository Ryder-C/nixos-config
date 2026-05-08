_: {
  ry.terminal.homeManager = {
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
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
      };
    };

    programs.zellij = {
      enable = true;
      settings = {
        session_serialization = false;
      };
    };
  };
}

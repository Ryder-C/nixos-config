_: {
  ry.terminal.homeManager = {pkgs, ...}: {
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
        bell = {
          duration = 100;
          command = {
            program = "${pkgs.pulseaudio}/bin/paplay";
            args = ["${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/window-attention.oga"];
          };
        };
        terminal.osc52 = "CopyPaste";
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

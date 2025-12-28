{
  programs.niri.settings = {
    window-rules = [
      {
        # Round corners for all windows
        geometry-corner-radius = {
          top-left = 10.0;
          top-right = 10.0;
          bottom-left = 10.0;
          bottom-right = 10.0;
        };
        clip-to-geometry = true;
      }
      {
        matches = [ { app-id = "^alacritty$"; } ];
        # Remove highlighting/borders for Alacritty
        focus-ring = {
          enable = false;
        };
      }
      {
        matches = [ { app-id = "^vesktop$"; } ];
        open-on-output = "DP-4";
        open-maximized = true;
      }
      {
        matches = [ { app-id = "^code$"; } ];
        open-maximized = true;
      }
      {
        matches = [ { app-id = "^antigravity$"; } ];
        open-maximized = true;
      }
    ];
  };
}

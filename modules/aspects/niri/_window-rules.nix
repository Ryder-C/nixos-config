_: {
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
        matches = [{app-id = "^alacritty$";}];
        focus-ring.enable = false;
      }
      {
        matches = [{app-id = "^vesktop$";}];
        open-on-output = "DP-2";
        open-maximized = true;
      }
      {
        matches = [
          {app-id = "^code$";}
          {app-id = "^antigravity$";}
        ];
        open-maximized = true;
      }
      {
        matches = [{app-id = "^org\\.jellyfin\\.JellyfinDesktop$";}];
        open-on-output = "DP-3";
      }
      {
        matches = [
          {app-id = "^.blueman-manager-wrapped$";}
          {app-id = "^[Ww]aydroid";}
          {app-id = "^org.gnome.Nautilus$";}
          {app-id = "^ninjabrainbot";}
          {
            app-id = "^thunar$";
            title = "^Rename";
          }
          {
            app-id = "^thunar$";
            title = "^File Operation Progress$";
          }
        ];
        open-floating = true;
      }
    ];
    layer-rules = [
      {
        matches = [{namespace = "^dms:notification-popup$";}];
        block-out-from = "screencast";
      }
    ];
  };
}

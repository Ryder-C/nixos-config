_: {
  den.aspects.sputnik.homeManager = {
    programs.niri.settings = {
      debug.render-drm-device = "/dev/dri/renderD128";
      switch-events = {
        lid-close.action.spawn = ["sh" "-c" "niri msg action power-off-monitors"];
        lid-open.action.spawn = ["sh" "-c" "sleep 0.5 && niri msg action power-on-monitors"];
      };
      outputs."eDP-1" = {
        mode = {
          width = 3024;
          height = 1964;
          refresh = 120.000;
        };
        scale = 2.0;
      };
    };
  };
}

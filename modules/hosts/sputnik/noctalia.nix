_: {
  # Laptop bar: drop the desktop widgets, add a battery indicator.
  den.aspects.sputnik.homeManager = {lib, ...}: {
    programs.noctalia.settings = {
      bar.main = {
        start = lib.mkForce ["control-center" "workspaces" "clock_date" "weather" "clock_time"];
        center = lib.mkForce [];
        end = lib.mkForce ["tray" "network" "bluetooth" "notifications" "battery_graphic"];
      };
      widget.battery_graphic = {
        type = "battery";
        display_mode = "graphic";
      };
    };
  };
}

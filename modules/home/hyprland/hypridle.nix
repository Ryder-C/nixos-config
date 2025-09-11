{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof swaylock || swaylock";
        before_sleep_cmd = "pidof swaylock || swaylock";
        ignore_systemd_inhibit = false;
        only_inactive_monitors = false;
      };

      listener = [
        # Lock after 10 minutes of inactivity
        {
          timeout = 600;
          "on-timeout" = "pidof hyprlock || hyprlock";
        }

        # Turn off monitors (DPMS) after 15 minutes
        {
          timeout = 900;
          "on-timeout" = "hyprctl dispatch dpms off";
          "on-resume" = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        # ignore_dbus_inhibit = false;
        lock_cmd = "pidof swaylock || swaylock";
        before_sleep_cmd = "loginctl lock-session";
        # ignore_systemd_inhibit = false;
        # only_inactive_monitors = false;
      };

      listener = [
        # Dim screen after 2.5 min
        {
          timeout = 150;
          "on-timeout" = "brightnessctl -s set 10";
          "on-resume" = "brightnessctl -r";
        }

        # Lock screen after 5 min
        {
          timeout = 300;
          "on-timeout" = "loginctl lock-session";
        }

        # Turn off monitors (DPMS) after 5.5 minutes
        {
          timeout = 330;
          "on-timeout" = "hyprctl dispatch dpms off";
          "on-resume" = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}

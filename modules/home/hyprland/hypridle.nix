{pkgs, ...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "pidof hyprlock || hyprlock";
        ignore_systemd_inhibit = false;
        only_inactive_monitors = false;
      };

      listener = [
        # Lock after 2 minutes of inactivity
        # {
        #   timeout = 120;
        #   "on-timeout" = "pidof hyprlock || hyprlock";
        # }

        # Turn off monitors (DPMS) after 3 minutes
        {
          timeout = 600;
          "on-timeout" = "hyprctl dispatch dpms off";
          "on-resume" = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}

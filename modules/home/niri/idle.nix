{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "niri msg action power-on-monitors";
        lock_cmd = "dms ipc lock lock";
        before_sleep_cmd = "loginctl lock-session";
      };

      listener = [
        # Lock screen after 5 min
        {
          timeout = 300;
          "on-timeout" = "loginctl lock-session";
        }

        # Turn off monitors (DPMS) after 5.5 minutes
        {
          timeout = 330;
          "on-timeout" = "niri msg action power-off-monitors";
          "on-resume" = "niri msg action power-on-monitors";
        }
      ];
    };
  };
}

{pkgs, ...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "dms ipc lock lock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };
      listener = [
        # Lock screen after 5 min
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        # Turn off monitors (DPMS) after 5.5 minutes
        {
          timeout = 330;
          on-timeout = "niri msg action power-off-monitors; ${pkgs.openrgb-with-all-plugins}/bin/openrgb -p off";
          on-resume = "niri msg action power-on-monitors; ${pkgs.openrgb-with-all-plugins}/bin/openrgb -p main";
        }
      ];
    };
  };
}

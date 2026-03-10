{pkgs, ...}: {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "loginctl lock-session";
      }
      {
        event = "after-resume";
        command = "niri msg action power-on-monitors";
      }
      {
        event = "lock";
        command = "dms ipc lock lock";
      }
    ];
    timeouts = [
      # Lock screen after 5 min
      {
        timeout = 300;
        command = "loginctl lock-session";
      }
      # Turn off monitors (DPMS) after 5.5 minutes
      {
        timeout = 330;
        command = "niri msg action power-off-monitors; ${pkgs.openrgb-with-all-plugins}/bin/openrgb -p off";
        resumeCommand = "niri msg action power-on-monitors; ${pkgs.openrgb-with-all-plugins}/bin/openrgb -p main";
      }
    ];
  };
}

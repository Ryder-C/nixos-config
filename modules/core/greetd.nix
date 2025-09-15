{username, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "Hyprland";
        user = "${username}";
      };
      default_session = {
        command = "Hyprland";
        user = "${username}";
      };
    };
  };
  systemd.services.greetd.wantedBy = ["graphical-session.target"];
}

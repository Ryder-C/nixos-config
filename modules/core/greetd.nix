{ username, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "niri-session";
        user = "${username}";
      };
      default_session = {
        command = "niri-session";
        user = "${username}";
      };
    };
  };
  systemd.services.greetd.wantedBy = [ "graphical-session.target" ];
}

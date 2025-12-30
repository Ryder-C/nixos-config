{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      # initial_session = {
      #   command = "niri-session";
      #   user = "${username}";
      # };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };
  systemd.services.greetd.wantedBy = [ "graphical-session.target" ];
}

{
  pkgs,
  inputs,
  username,
  ...
}: {
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     # initial_session = {
  #     #   command = "niri-session";
  #     #   user = "${username}";
  #     # };
  #     default_session = {
  #       command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
  #       user = "greeter";
  #     };
  #   };
  # };
  # systemd.services.greetd.wantedBy = [ "graphical-session.target" ];
  services.displayManager.dms-greeter = {
    enable = true;
    compositor = {
      name = "niri";
      customConfig = ''
        output "DP-5" {
            scale 1.500000
            position x=2560 y=0
            mode "3840x2160@59.997000"
        }
        output "DP-6" {
            scale 1.500000
            transform "normal"
            position x=0 y=0
            mode "3840x2160@239.996000"
        }
        hotkey-overlay { skip-at-startup; }
      '';
    };

    configHome = "/home/${username}";
    configFiles = [
      "/home/${username}/.config/DankMaterialShell/settings.json"
      "/home/${username}/.local/state/DankMaterialShell/session.json"
    ];

    package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}

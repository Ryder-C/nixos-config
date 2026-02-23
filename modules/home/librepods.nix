{inputs, pkgs, ...}: {
  home.packages = [
    inputs.librepods.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  systemd.user.services.librepods = {
    Unit = {
      Description = "LibrePods";
      After = ["graphical-session.target" "tray.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "${inputs.librepods.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/librepods --start-minimized";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}

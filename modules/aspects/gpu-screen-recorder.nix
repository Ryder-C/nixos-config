_: {
  ry.gpu-screen-recorder = {
    nixos = {
      programs.gpu-screen-recorder.enable = true;
    };

    homeManager = {
      pkgs,
      config,
      ...
    }: {
      programs.dank-material-shell.plugins.gpuScreenRecorder.src = ./_dms-plugins/gpu-screen-recorder;

      systemd.user.services.gpu-screen-recorder = {
        Unit = {
          Description = "GPU Screen Recorder - Replay Buffer";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w DP-3 -c mp4 -f 60 -a default_output -r 120 -o /home/${config.home.username}/Videos";
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };

    };
  };
}

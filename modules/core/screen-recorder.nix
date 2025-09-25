{pkgs, ...}: {
  programs.gpu-screen-recorder.enable = true;

  # environment.systemPackages = [pkgs.gpu-screen-recorder-gtk];

  systemd.user.services.gsr-replay = {
    description = "GPU Screen Recorder (instant replay)";
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];

    serviceConfig = {
      # Wayland user service needs this
      Environment = "XDG_RUNTIME_DIR=%t";
      # Your UI settings, translated to CLI:
      # -w DP-5   (capture that monitor; use -w screen to grab all)
      # -f 60     (fps)
      # -r 30     (replay buffer seconds)
      # -c mp4    (container)
      # -o %h/Videos
      # -bm cbr -b 15000k  (CBR ~15 Mbps)
      # -a <sink>.monitor  (default output audio)
      ExecStart = ''
        ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder \
          -w portal \
          -restore-portal-session yes \
          -f 60 \
          -r 60 \
          -c mp4 \
          -o %h/Videos \
          -bm cbr -q 8000 \
      '';
      Restart = "on-failure";
    };
  };
}

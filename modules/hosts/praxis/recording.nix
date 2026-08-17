{ry, ...}: {
  den.aspects.praxis = {
    includes = [ry.gpu-screen-recorder];

    nixos = let
      # Both portal units ship an empty WantedBy, so nothing has started them at
      # login. The screen_recorder plugin won't arm the replay buffer unless it
      # can see both running (it scans /proc) and never triggers the D-Bus
      # activation that would start them — a deadlock, not a race.
      startWithSession = {
        overrideStrategy = "asDropin";
        wantedBy = ["graphical-session.target"];
      };
    in {
      systemd.user.services = {
        xdg-desktop-portal = startWithSession;
        xdg-desktop-portal-gnome = startWithSession;
      };
    };

    homeManager = {
      config,
      lib,
      pkgs,
      ...
    }: {
      # Kill the replay buffer at logout ourselves. It lives in noctalia's
      # transient scope, which systemd stops in the same instant as niri and
      # pipewire; gpu-screen-recorder's SIGTERM handler only sets a flag its
      # capture loop polls, and that loop is already blocked on a capture source
      # that has gone away. So it hangs until the 90s stop timeout SIGKILLs it —
      # we just send that SIGKILL up front. The ring buffer is RAM-only and
      # dropped at session end anyway; the only cost is truncating a
      # replay-save that was in flight.
      #
      # `recorde[r]` stops pkill matching the ExecStop script itself. The
      # trailing space in `-r ` is what tells a replay buffer apart from a plain
      # recording, so the quotes are load-bearing.
      systemd.user.services.gpu-screen-recorder-replay-stop = {
        Unit = {
          Description = "Stop noctalia's gpu-screen-recorder replay buffer at session exit";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
        };
        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.coreutils}/bin/true";
          # `|| true` because pkill exits 1 when nothing matched, which is
          # normal for a session that never armed the buffer.
          ExecStop = pkgs.writeShellScript "stop-gpu-screen-recorder-replay" ''
            ${pkgs.procps}/bin/pkill -KILL -f 'gpu-screen-recorde[r].*-r ' || true
          '';
        };
        Install.WantedBy = ["graphical-session.target"];
      };

      # Arm the replay buffer for the session. It only writes a file when asked
      # to (the bar icon), so logout just drops the ring buffer.
      #
      # Poll for the process rather than trusting msg's exit status: msg
      # succeeds as soon as the plugin loads, but replay-start still fails
      # silently if the portal isn't up yet. replay-start is a no-op once the
      # recorder is running, so retries are free.
      programs.noctalia.settings.hooks.started = let
        noctalia = lib.getExe config.programs.noctalia.package;
      in "i=0; while [ $i -lt 30 ]; do pgrep -f 'gpu-screen-recorde[r].*-r ' >/dev/null 2>&1 && break; ${noctalia} msg plugin noctalia/screen_recorder:service all replay-start >/dev/null 2>&1; i=$((i+1)); sleep 2; done";
    };
  };
}

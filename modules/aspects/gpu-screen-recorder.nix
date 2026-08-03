_: {
  # Provides the gpu-screen-recorder binary and its setuid capture helper.
  # The replay buffer itself is owned by noctalia's screen_recorder plugin
  # (see noctalia.nix): it arms the buffer at session start and saves it on
  # demand. Running a second buffer here would fight it -- the plugin's
  # save/stop is a `pkill -f 'gpu-screen-recorder.*-r '`, which matches any
  # replay process, not just its own.
  ry.gpu-screen-recorder.nixos = {
    programs.gpu-screen-recorder.enable = true;
  };
}

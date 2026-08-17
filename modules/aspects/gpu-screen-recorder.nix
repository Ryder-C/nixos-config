_: {
  # Just the binary and its setuid capture helper. The replay buffer belongs to
  # noctalia's screen_recorder plugin (armed in hosts/praxis/recording.nix) --
  # a second buffer here would fight it, since the plugin's stop is a
  # `pkill -f` that matches any replay process.
  ry.gpu-screen-recorder.nixos = {
    programs.gpu-screen-recorder.enable = true;
  };
}

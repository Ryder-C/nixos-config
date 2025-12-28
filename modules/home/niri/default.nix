_: {
  imports = [
    ./config.nix
    ./idle.nix
    ./window-rules.nix
  ];

  programs.niri.enable = true;
}

{inputs, ...}: {
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpanel.nix
    ./variables.nix
  ];
}

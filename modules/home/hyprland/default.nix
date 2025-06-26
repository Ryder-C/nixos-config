{inputs, ...}: {
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./hyprpanel.nix
    ./variables.nix
  ];
  services.hypridle.enable = true;
}

{inputs, ...}: {
  imports = [
    ./bootloader.nix
    ./hardware.nix
    ./nvidia.nix
    ./xserver.nix
    ./network.nix
    ./bluetooth.nix
    ./pipewire.nix
    ./program.nix
    ./security.nix
    ./services.nix
    # ./looking-glass-client.nix
    ./system.nix
    ./user.nix
    ./steam.nix
    ./wayland.nix
    ./virtualization.nix
    ./age.nix
    ./aagl.nix
    ./greetd.nix
  ];
}

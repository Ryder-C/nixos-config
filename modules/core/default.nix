{...}: {
  imports = [
    ./bootloader.nix
    ./hardware.nix
    ./nvidia.nix
    ./network.nix
    ./bluetooth.nix
    ./pipewire.nix
    ./program.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./user.nix
    ./steam.nix
    ./wayland.nix
    ./virtualization.nix
    ./age.nix
    ./aagl.nix
    ./greetd.nix
    ./nixarr.nix
    ./monado.nix
    ./sunshine.nix
  ];
}

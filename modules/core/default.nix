{inputs, ...}: {
  imports = [
    inputs.agenix.nixosModules.default
    inputs.nix-pia-vpn.nixosModules.default
    # inputs.rednix.container

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
    ./system.nix
    ./user.nix
    ./steam.nix
    ./wayland.nix
    ./virtualization.nix
    ./age.nix
    ./aagl.nix
  ];
}

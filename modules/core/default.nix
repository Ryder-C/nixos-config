{
  inputs,
  nixpkgs,
  self,
  username,
  host,
  ...
}: {
  imports =
    [(import ./bootloader.nix)]
    ++ [(import ./hardware.nix)]
    ++ [(import ./hardware-acceleration.nix)]
    ++ [(import ./nvidia.nix)]
    ++ [(import ./xserver.nix)]
    ++ [(import ./network.nix)]
    ++ [(import ./bluetooth.nix)]
    ++ [(import ./pipewire.nix)]
    ++ [(import ./program.nix)]
    ++ [(import ./security.nix)]
    ++ [(import ./services.nix)]
    ++ [(import ./system.nix)]
    ++ [(import ./user.nix)]
    ++ [(import ./steam.nix)]
    ++ [(import ./wayland.nix)]
    ++ [(import ./virtualization.nix)]
    ++ [(import ./age.nix)]
    ++ [(import ./aagl.nix)];
}

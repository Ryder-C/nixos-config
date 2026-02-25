{
  host,
  lib,
  ...
}: {
  imports =
    [
      ./bootloader.nix
      ./hardware.nix
      ./network.nix
      ./bluetooth.nix
      ./pipewire.nix
      ./program.nix
      ./security.nix
      ./services.nix
      ./system.nix
      ./user.nix
      ./wayland.nix
      ./virtualization.nix
      ./age.nix
      ./greetd.nix
      ./memory.nix
    ]
    ++ lib.optionals (host != "laptop") [
      ./nvidia.nix
      ./steam.nix
      ./nixarr.nix
      ./star-citizen.nix
      ./aagl.nix
      ./gpu-screen-recorder.nix
      # ./plasma.nix
      # ./sunshine.nix
    ];
}

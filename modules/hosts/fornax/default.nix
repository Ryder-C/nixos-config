{ry, ...}: {
  den.aspects.fornax = {
    includes = [
      ry.base
      ry.nixarr
      ry.tailscale
    ];

    nixos = {pkgs, ...}: {
      imports = [./_hardware-configuration.nix];

      # Headless server optimizations
      networking.firewall.enable = true;
      services.openssh.enable = true;
    };
  };
}

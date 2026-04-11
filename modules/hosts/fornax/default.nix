{ry, ...}: {
  den.aspects.fornax = {
    includes = [
      ry.base
      # ry.nixarr
      ry.tailscale
      ry.rgb
      ry.nvidia
    ];

    nixos = {
      lib,
      config,
      ...
    }: {
      imports = [./_hardware-configuration.nix];

      # Headless server optimizations
      networking.firewall.enable = true;
      services = {
        openssh.enable = true;
        greetd.enable = false;
      };

      hardware.nvidia = {
        open = lib.mkForce false;
        package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      };

      programs = {
        gamescope.enable = true;
        steam = {
          enable = true;
          gamescopeSession.enable = true;
        };
      };
    };
  };
}

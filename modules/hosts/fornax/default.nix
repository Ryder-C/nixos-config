{ry, ...}: {
  den.aspects.fornax = {
    includes = [
      ry.base
      ry.packages
      ry.homepage
      # ry.ente
      ry.minecraft
      # ry.forgejo
      ry.nixflix
      ry.caddy
      ry.tailscale
      ry.vaultwarden
      ry.rgb
      ry.nvidia
      ry.audio
      ry.gamescope-kiosk
    ];

    nixos = {
      lib,
      config,
      ...
    }: {
      imports = [./_hardware-configuration.nix];

      boot.supportedFilesystems = ["bcachefs"];

      # Headless server optimizations
      networking.firewall.enable = true;
      services = {
        openssh.enable = true;
        greetd.enable = false;
      };

      hardware.nvidia = {
        open = lib.mkForce false;
        package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.legacy_580;
      };
    };
  };
}

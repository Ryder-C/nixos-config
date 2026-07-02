{ry, ...}: {
  den.aspects.fornax = {
    includes = [
      ry.base
      ry.packages
      ry.homepage
      # ry.ente
      ry.minecraft
      ry.guessr
      # ry.forgejo
      ry.nixflix
      ry.caddy
      ry.tailscale
      ry.uptime-kuma
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

      # Never suspend/hibernate: GNOME/GDM idle would otherwise sleep the
      # server and take down all hosted services. Masking the sleep targets
      # blocks it regardless of GNOME power settings or the GDM greeter.
      systemd.targets = {
        sleep.enable = false;
        suspend.enable = false;
        hibernate.enable = false;
        hybrid-sleep.enable = false;
      };

      hardware.nvidia = {
        open = lib.mkForce false;
        package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.legacy_580;
      };
    };
  };
}

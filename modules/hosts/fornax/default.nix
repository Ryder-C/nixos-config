{ry, ...}: {
  den.aspects.fornax = {
    includes = [
      ry.base
      ry.homepage
      ry.ente
      ry.nixflix
      ry.torrents
      ry.caddy
      ry.tailscale
      ry.rgb
      ry.nvidia
      ry.audio
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
        package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      };

      programs = {
        gamescope.enable = true;
        steam = {
          enable = true;
          gamescopeSession = {
            enable = true;
            args = [
              # "--backend sdl"
              "-W 3840"
              "-H 2160"
              "-w 3840"
              "-h 2160"
              "-r 60"
              "-o 60"
              "--force-grab-cursor"
            ];
          };
        };
      };
    };
  };
}

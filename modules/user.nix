{den, ...}: {
  den = {
    aspects.ryder = {
      includes = [
        den._.primary-user
        (den._.user-shell "fish")
        den._.host-aspects
      ];

      nixos = {config, ...}: {
        users.users.ryder = {
          isNormalUser = true;
          description = "ryder";
          extraGroups = ["networkmanager" "wheel" "dialout" "input" "uinput" "seat" "docker" "libvirtd"];
          # Keep user services (libvirtd sessions, timers) alive across logout.
          linger = true;
        };
        nix.settings.allowed-users = ["ryder"];

        # ryder's SSH key is what agenix decrypts host secrets with.
        age.identityPaths = ["${config.users.users.ryder.home}/.ssh/id_ed25519"];

        # NH_FLAKE for bare `nh os switch`; the shell aliases pass it explicitly.
        programs.nh.flake = "${config.users.users.ryder.home}/nixos-config";
      };

      homeManager = {pkgs, ...}: {
        home.username = "ryder";
        home.homeDirectory =
          if pkgs.stdenv.isDarwin
          then "/Users/ryder"
          else "/home/ryder";
      };
    };

    hosts = {
      x86_64-linux = {
        praxis.users.ryder = {};
        tabula.users.ryder = {};
        fornax.users.ryder = {};
      };
      aarch64-linux.sputnik.users.ryder = {};
      aarch64-darwin.umbra.users.ryder = {};
    };
  };
}

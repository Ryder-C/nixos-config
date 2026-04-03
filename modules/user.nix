{den, ...}: {
  den = {
    aspects.ryder = {
      includes = [
        den._.primary-user
        (den._.user-shell "fish")
      ];

      nixos = _: {
        users.users.ryder = {
          isNormalUser = true;
          description = "ryder";
          extraGroups = ["networkmanager" "wheel" "dialout" "input" "uinput" "seat" "docker"];
        };
        nix.settings.allowed-users = ["ryder"];
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

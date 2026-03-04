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

      homeManager = {
        home.username = "ryder";
        home.homeDirectory = "/home/ryder";
      };
    };

    hosts = {
      x86_64-linux.desktop.users.ryder = {};
      aarch64-linux.laptop.users.ryder = {};
      x86_64-linux.vm.users.ryder = {};
    };
  };
}

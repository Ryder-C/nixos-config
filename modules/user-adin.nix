{den, ...}: {
  den = {
    aspects.adin = {
      includes = [
        den._.primary-user
        (den._.user-shell "fish")
      ];

      nixos = _: {
        users.users.adin = {
          isNormalUser = true;
          description = "adin";
          extraGroups = ["networkmanager" "wheel" "dialout" "input" "uinput" "seat" "docker"];
          initialPassword = "adin123";
        };
        nix.settings.allowed-users = ["adin"];
      };

      homeManager = {pkgs, ...}: {
        home.username = "adin";
        home.homeDirectory = "/home/adin";

        # --- Adin's overrides ---
      };
    };

    hosts.x86_64-linux.fornax.users.adin = {};
  };
}

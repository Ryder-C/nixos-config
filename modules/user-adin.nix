{
  den,
  ry,
  ...
}: {
  den = {
    aspects.adin = {
      includes = [
        den._.primary-user
        (den._.user-shell "fish")
        den._.host-aspects
        ry.cosmic
        ry.discord
        ry.browser
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

{
  den,
  inputs,
  ...
}: {
  flake-file.inputs.adin-configs.url = "github:AdinAck/nix-configs";

  den = {
    aspects.adin = {
      includes = [
        den._.primary-user
        (den._.user-shell "fish")
      ];

      nixos = _: {
        # Adin's system-level GNOME (xserver + gdm + gnome desktop, host-wide)
        imports = [inputs.adin-configs.system-aspects.gnome];

        users.users.adin = {
          isNormalUser = true;
          description = "adin";
          extraGroups = ["networkmanager" "wheel" "dialout" "input" "uinput" "seat" "docker"];
          initialPassword = "adin123";
        };
        nix.settings.allowed-users = ["adin"];
      };

      homeManager = {...}: {
        home.username = "adin";
        home.homeDirectory = "/home/adin";

        # Pull in all of Adin's home-manager aspects
        imports = builtins.attrValues inputs.adin-configs.user-aspects;
      };
    };

    hosts.x86_64-linux.fornax.users.adin = {};
  };
}

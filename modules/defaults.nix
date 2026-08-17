{
  den,
  inputs,
  ...
}: let
  # Extra module args every class gets: `stablePkgs` for things that lag on
  # unstable, and platform booleans for `lib.optionals isLinux` lists.
  commonArgs = {pkgs, ...}: {
    _module.args = {
      stablePkgs = import inputs.nixpkgs-stable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
      inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
    };
  };
in {
  den = {
    schema.user = {lib, ...}: {
      config.classes = lib.mkDefault ["homeManager"];
    };

    default = {
      nixos = {
        imports = [commonArgs];
        system.stateVersion = "24.05";
      };
      darwin = {
        imports = [commonArgs];
        system.stateVersion = 6;
      };
      homeManager = {
        imports = [commonArgs];
        home.stateVersion = "24.05";
        programs.home-manager.enable = true;
      };

      includes = [
        den._.define-user

        (
          {host, ...}: {
            ${host.class} = {
              networking.hostName = host.hostName;
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                backupCommand = "rm -f";
              };
            };
          }
        )
      ];
    };
  };
}

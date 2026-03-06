{
  den,
  inputs,
  ...
}: {
  den.schema.user = {lib, ...}: {
    config.classes = lib.mkDefault ["homeManager"];
  };

  den.default = {
    nixos = {pkgs, ...}: {
      system.stateVersion = "24.05";
      _module.args.stablePkgs = import inputs.nixpkgs-stable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    };
    homeManager = {pkgs, ...}: {
      home.stateVersion = "24.05";
      programs.home-manager.enable = true;
      _module.args.stablePkgs = import inputs.nixpkgs-stable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    };

    includes = [
      den._.define-user

      (den.lib.take.exactly (
        {host}: {
          nixos.networking.hostName = host.hostName;
          nixos.home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            backupCommand = "rm -f";
          };
        }
      ))
    ];
  };
}

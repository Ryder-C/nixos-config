{
  den,
  inputs,
  lib,
  ...
}: {
  den = {
    schema.user = {lib, ...}: {
      config.classes = lib.mkDefault ["homeManager"];
    };

    default = {
      nixos = {pkgs, ...}: {
        system.stateVersion = "24.05";
        _module.args.stablePkgs = import inputs.nixpkgs-stable {
          inherit (pkgs.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
        _module.args.isLinux = pkgs.stdenv.hostPlatform.isLinux;
        _module.args.isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      };
      darwin = {pkgs, ...}: {
        system.stateVersion = 6;
        _module.args.stablePkgs = import inputs.nixpkgs-stable {
          inherit (pkgs.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
        _module.args.isLinux = pkgs.stdenv.hostPlatform.isLinux;
        _module.args.isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      };
      homeManager = {pkgs, ...}: {
        home.stateVersion = "24.05";
        programs.home-manager.enable = true;
        _module.args.stablePkgs = import inputs.nixpkgs-stable {
          inherit (pkgs.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
        _module.args.isLinux = pkgs.stdenv.hostPlatform.isLinux;
        _module.args.isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
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

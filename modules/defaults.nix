{
  den,
  inputs,
  lib,
  ...
}: {
  den.schema.user = {lib, ...}: {
    config.classes = lib.mkDefault ["homeManager"];
  };

  # Forward host aspects into home-manager user environments
  den.ctx.hm-user.includes = [
    ({host, user}:
      den._.forward {
        each = lib.singleton true;
        fromClass = _: "homeManager";
        intoClass = _: host.class;
        intoPath = _: [
          "home-manager"
          "users"
          user.userName
        ];
        fromAspect = _: den.aspects.${host.aspect};
      })
  ];

  den.default = {
    nixos = {pkgs, ...}: {
      system.stateVersion = "24.05";
      _module.args.stablePkgs = import inputs.nixpkgs-stable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    };
    darwin = {pkgs, ...}: {
      system.stateVersion = 6;
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
          ${host.class} = {
            networking.hostName = host.hostName;
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupCommand = "rm -f";
            };
          };
        }
      ))
    ];
  };
}

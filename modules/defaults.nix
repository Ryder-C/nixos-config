{den, ...}: {
  den.base.user.classes = ["homeManager"];

  den.default = {
    nixos.system.stateVersion = "24.05";
    homeManager.home.stateVersion = "24.05";
    homeManager.programs.home-manager.enable = true;

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

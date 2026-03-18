{inputs, ...}: {
  flake-file.inputs.rycharger = {
    url = "github:Ryder-C/rycharger";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.charger.nixos = {...}: {
    imports = [inputs.rycharger.nixosModules.default];

    services.rycharger = {
      enable = true;
      settings = {
        battery.device = "macsmc-battery";
      };
    };
  };
}

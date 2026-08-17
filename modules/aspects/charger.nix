{inputs, ...}: {
  flake-file.inputs.rycharger = {
    url = "github:Ryder-C/rycharger";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # The battery device is host-specific; hosts set services.rycharger.settings.
  ry.charger.nixos = {...}: {
    imports = [inputs.rycharger.nixosModules.default];
    services.rycharger.enable = true;
  };
}

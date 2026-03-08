{inputs, ...}: {
  flake-file.inputs.rycharger = {
    url = "github:Ryder-C/rycharger";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.charger.nixos = {username, ...}: {
    imports = [inputs.rycharger.nixosModules.default];

    services.rycharger = {
      enable = true;
      user = "${username}";
      settings = {
        battery.hold_percent = 80;
      };
    };
  };
}

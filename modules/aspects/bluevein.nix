{inputs, ...}: {
  ry.bluevein.nixos = {...}: {
    imports = [inputs.rypkgs.nixosModules.bluevein];
    services.bluevein.enable = true;
  };
}

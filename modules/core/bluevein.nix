{inputs, ...}: {
  imports = [inputs.rypkgs.nixosModules.bluevein];
  services.bluevein.enable = true;
}

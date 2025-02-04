{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
    inputs.agenix.nixosModules.default
    inputs.nix-pia-vpn.nixosModules.default
  ];

  powerManagement.cpuFreqGovernor = "performance";
}

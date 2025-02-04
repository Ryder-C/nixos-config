{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
    inputs.agenix.nixosModules.default
  ];

  powerManagement.cpuFreqGovernor = "performance";
}

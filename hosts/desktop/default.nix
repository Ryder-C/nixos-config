{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
    inputs.agenix.nixosModules.default
    inputs.nix-pia-vpn.nixosModules.default
  ];

  powerManagement.cpuFreqGovernor = "performance";
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  boot.kernelModules = [
    "v4l2loopback"
  ];
}

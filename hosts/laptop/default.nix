{
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    powertop
  ];

  services = {
    power-profiles-daemon.enable = true;

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };
  };
}

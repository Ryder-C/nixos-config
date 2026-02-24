{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    cpupower-gui
    powertop
  ];

  boot.extraModprobeConfig = "options appledrm show_notch=1";

  boot.binfmt.emulatedSystems = ["x86_64-linux"];

  systemd.tmpfiles.rules = [
    "w /sys/class/power_supply/macsmc-battery/charge_control_end_threshold - - - - 80"
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

  powerManagement.cpuFreqGovernor = "performance";

  boot = {
    kernelModules = ["acpi_call"];
    extraModulePackages = with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
      ]
      ++ [pkgs.cpupower-gui];
  };
}

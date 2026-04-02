{
  inputs,
  ry,
  lib,
  ...
}: {
  flake-file.inputs.apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";

  den.aspects.sputnik = {
    includes = [
      ry.workstation
      ry.niri-sputnik
      ry.greetd-sputnik
      ry.charger
      ry.tailscale
    ];

    nixos = {
      pkgs,
      config,
      ...
    }: {
      imports = [
        inputs.apple-silicon-support.nixosModules.apple-silicon-support
        ./_hardware-configuration.nix
      ];

      environment.systemPackages = with pkgs; [
        acpi
        brightnessctl
        cpupower-gui
        powertop
      ];

      boot = {
        extraModprobeConfig = "options appledrm show_notch=1";
        binfmt.emulatedSystems = ["x86_64-linux"];
      };

      services = {
        rycharger.settings.battery.device = "macsmc-battery";
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

      # Laptop-specific lid switch behavior
      services.logind.settings.Login = {
        HandleLidSwitch = lib.mkForce "suspend";
        HandleLidSwitchExternalPower = lib.mkForce "suspend";
      };

      # Apple Silicon cache
      nix.settings = {
        substituters = ["https://nixos-apple-silicon.cachix.org"];
        trusted-public-keys = [
          "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
        ];
      };
    };

    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.jellyfin-desktop];
    };
  };
}

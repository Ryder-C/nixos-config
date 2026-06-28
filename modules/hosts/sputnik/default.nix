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
      ry.noctalia-sputnik
      ry.charger
      ry.tailscale
    ];

    nixos = {
      pkgs,
      config,
      ...
    }: let
      toggleInternalKb = pkgs.writeShellScript "toggle-internal-kb" ''
        # Check if any bluetooth keyboard is currently connected
        bt_kb_connected=false
        for dev in /sys/class/input/input*/; do
          [ -d "$dev" ] || continue
          bustype=$(cat "$dev/id/bustype" 2>/dev/null) || continue
          # bustype 0005 = bluetooth
          [ "$bustype" = "0005" ] || continue
          # Keyboards have long key capability bitmasks vs mice/other HID
          keys=$(cat "$dev/capabilities/key" 2>/dev/null) || continue
          if [ "''${#keys}" -gt 20 ]; then
            bt_kb_connected=true
            break
          fi
        done

        # Inhibit or uninhibit the internal Apple keyboard
        for dev in /sys/class/input/input*/; do
          [ -d "$dev" ] || continue
          name=$(cat "$dev/name" 2>/dev/null) || continue
          case "$name" in
            *Apple*Keyboard*|*apple*keyboard*)
              if [ "$bt_kb_connected" = true ]; then
                echo 1 > "$dev/inhibited" 2>/dev/null
              else
                echo 0 > "$dev/inhibited" 2>/dev/null
              fi
              ;;
          esac
        done
      '';
    in {
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
        loader.efi.canTouchEfiVariables = lib.mkForce false;
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

      # Disable internal keyboard when a bluetooth keyboard is connected
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_KEYBOARD}=="1", RUN+="${toggleInternalKb}"
        ACTION=="remove", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_KEYBOARD}=="1", RUN+="${toggleInternalKb}"
      '';

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
  };
}

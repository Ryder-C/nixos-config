{
  pkgs,
  inputs,
  host,
  config,
  lib,
  ...
}: let
  inherit (lib) hasSuffix;
  cfgDir = "${config.xdg.configHome}/waybar";
  customModules = pkgs.runCommandLocal "mechabar-modules-custom-${inputs.mechabar.rev or "src"}" {} ''
mkdir -p "$out"
cp -r ${inputs.mechabar}/modules/. "$out"/
chmod -R u+w "$out"

cat <<'EOF' > "$out/custom/system_update.jsonc"
{
  "custom/system_update": {
    "exec": "~/.config/waybar/scripts/system-update.sh module",
    "return-type": "json",
    "interval": 3600,
    "format": "{}",
    "min-length": 2,
    "max-length": 2,
    "on-click": "~/.config/waybar/scripts/system-update.sh"
  }
}
EOF

cat <<'EOF' > "$out/custom/distro.jsonc"
{
  "custom/distro": {
    "format": "",
    "tooltip": false
  }
}
EOF

cat <<'EOF' > "$out/custom/power_menu.jsonc"
{
  "custom/power_menu": {
    "format": "󰤄",
    "on-click": "hyprctl dispatch exec 'wlogout'",
    "tooltip-format": "Power Menu"
  }
}
EOF

cat <<'EOF' > "$out/bluetooth.jsonc"
{
  "bluetooth": {
    "format": "󰂯",
    "format-disabled": "󰂲",
    "format-off": "󰂲",
    "format-on": "󰂰",
    "format-connected": "󰂱",
    "min-length": 2,
    "max-length": 2,
    "on-click": "hyprctl dispatch exec '[float] blueman-manager'",
    "on-click-right": "bluetoothctl power off && notify-send 'Bluetooth Off' -i 'network-bluetooth-inactive' -r 1925",
    "tooltip-format": "Device Addr: {device_address}",
    "tooltip-format-disabled": "Bluetooth Disabled",
    "tooltip-format-off": "Bluetooth Off",
    "tooltip-format-on": "Bluetooth Disconnected",
    "tooltip-format-connected": "Device: {device_alias}",
    "tooltip-format-enumerate-connected": "Device: {device_alias}",
    "tooltip-format-connected-battery": "Device: {device_alias}\\nBattery: {device_battery_percentage}%",
    "tooltip-format-enumerate-connected-battery": "Device: {device_alias}\\nBattery: {device_battery_percentage}%"
  }
}
EOF

cat <<'EOF' > "$out/temperature.jsonc"
{
  "temperature": {
    "hwmon-path": "/sys/class/hwmon/hwmon3/temp1_input",
    "critical-threshold": 90,
    "interval": 10,
    "format-critical": "󰀦 {temperatureC}°C",
    "format": "{icon} {temperatureC}°C",
    "format-icons": [
      "󱃃",
      "󰔏",
      "󱃂"
    ],
    "min-length": 8,
    "max-length": 8,
    "tooltip-format": "Temp in Fahrenheit: {temperatureF}°F"
  }
}
EOF
'';
  modulesDir = customModules;

  jsoncFiles = dir: let
    entries = builtins.readDir dir;
  in
    builtins.filter
    (file: let
      type = entries.${file};
    in
      (type == "regular" || type == "symlink") && hasSuffix ".jsonc" file)
    (builtins.attrNames entries);

  mkIncludePaths = relDir: let
    files = jsoncFiles (modulesDir + relDir);
    prefix = "${cfgDir}/modules${relDir}";
  in
    map (file: "${prefix}/${file}") files;

  includePaths =
    mkIncludePaths ""
    ++ mkIncludePaths "/custom"
    ++ mkIncludePaths "/hyprland";

  includeJson = builtins.toJSON includePaths;
in {
  imports = [
    # ./waybar.nix
    # ./settings.nix
    # ./style.nix
  ];

  programs.wlogout = {
    enable = true;
  };

  home.packages = with pkgs; [
    waybar

    # Dependencies from sejjy/mechabar's scripts
    bluez # bluetooth.sh
    bluez-tools # bluetooth.sh
    brightnessctl # backlight.sh
    fzf # Used by all menu scripts (bluetooth.sh, network.sh, power-menu.sh)
    networkmanager # For nmcli in network.sh
    pkgs.nerd-fonts._0xproto
    libnotify # For notify-send in scripts
    nh

    # For volume.sh script
    pulseaudio # For pactl
  ];

  xdg.configFile = {
    # Link sub-directories from the mechabar flake input
    "waybar/modules" = {source = customModules;};
    "waybar/styles" = {
      source = inputs.mechabar + "/styles";
      recursive = true;
    };
    "waybar/themes" = {
      source = inputs.mechabar + "/themes";
      recursive = true;
    };

    "waybar/style.css" = {
      text = ''
        * {
        	all: initial; /* ignore GTK theme */
        }

        @import "styles/modules-center.css";
        @import "styles/modules-left.css";
        @import "styles/modules-right.css";
        @import "styles/states.css";
        @import "styles/typeface.css";
        @import "styles/waybar.css";
        @import "theme.css";
        @import "styles/custom.css";
      '';
    };
    "waybar/theme.css" = {source = inputs.mechabar + "/theme.css";};
    "waybar/modules/custom/system_update.jsonc" = {
      text = ''
        {
          "custom/system_update": {
            "exec": "~/.config/waybar/scripts/system-update.sh module",
            "return-type": "json",
            "interval": 3600,
            "format": "{}",
            "min-length": 2,
            "max-length": 2,
            "on-click": "~/.config/waybar/scripts/system-update.sh"
          }
        }
      '';
    };
    "waybar/styles/custom.css" = {
      text = ''
        #custom-distro {
          padding: 0 8px 0 0px;
        }
      '';
    };

    # Link scripts *except* system-update.sh
    "waybar/scripts/backlight.sh" = {
      source = inputs.mechabar + "/scripts/backlight.sh";
      executable = true;
    };
    "waybar/scripts/bluetooth.sh" = {
      source = inputs.mechabar + "/scripts/bluetooth.sh";
      executable = true;
    };
    "waybar/scripts/fzf-colors.sh" = {
      source = inputs.mechabar + "/scripts/fzf-colors.sh";
      executable = true;
    };
    "waybar/scripts/network.sh" = {
      source = inputs.mechabar + "/scripts/network.sh";
      executable = true;
    };
    "waybar/scripts/power-menu.sh" = {
      source = inputs.mechabar + "/scripts/power-menu.sh";
      executable = true;
    };
    "waybar/scripts/volume.sh" = {
      source = inputs.mechabar + "/scripts/volume.sh";
      executable = true;
    };

    # --- ADD OUR OVERRIDDEN FILES ---

    # Override config.jsonc to use explicit paths
    "waybar/config.jsonc" = {
      text = ''
        {
          "include": ${includeJson},
          "modules-left": [
            "group/user", "custom/left_div#1", "hyprland/workspaces",
            "custom/right_div#1", "hyprland/window"
          ],
          "modules-center": [
            "hyprland/windowcount", "custom/left_div#2", "temperature",
            "custom/left_div#3", "memory", "custom/left_div#4", "cpu",
            "custom/left_inv#1", "custom/left_div#5", "custom/distro",
            "custom/right_div#2", "custom/right_inv#1", "idle_inhibitor",
            "clock#time", "custom/right_div#3", "clock#date",
            "custom/right_div#4", "network", "bluetooth",
            "custom/system_update", "custom/right_div#5"
          ],
          "modules-right": [
            "mpris", "custom/left_div#6", "group/pulseaudio",
            "custom/left_div#7", "backlight", "custom/left_div#8",
            "battery", "custom/left_inv#2", "custom/power_menu"
          ],
          "layer": "top",
          "mode": "dock",
          "reload_style_on_change": true
        }
      '';
    };
    "waybar/scripts/system-update.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        if [[ "$1" != "module" ]]; then
          FLAKE_DIR="''${FLAKE_DIR:-$HOME/nixos-config}"
          hyprctl dispatch exec "[float] alacritty -e bash -lc 'cd \"''${FLAKE_DIR}\" && echo \">>> Running nix flake update and switch...\" && nh os switch --hostname ${host} --update \"''${FLAKE_DIR}?submodules=1\" && echo \">>> Optimising nix store...\" && nix-store --optimise && echo \">>> Done!\" && read -n 1 -p \"Press any key to close...\"'"
          exit 0
        fi

        GENERATION_COUNT=$(ls -l /nix/var/nix/profiles/ | grep -c "system-[0-9]*-link")
        CURRENT_GEN=$(readlink /nix/var/nix/profiles/system | grep -o -E '[0-9]+')
        TEXT=""
        TOOLTIP="Current Generation: $CURRENT_GEN\nLocal Generations: $GENERATION_COUNT"

        echo "{\"text\": \"$TEXT\", \"tooltip\": \"$TOOLTIP\"}"
      '';
    };
  };

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      WorkingDirectory = "%E/waybar";
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}

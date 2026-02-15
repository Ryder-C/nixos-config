{
  inputs,
  config,
  username,
  ...
}: {
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    inputs.nix-monitor.homeManagerModules.default
  ];

  home.sessionVariables = {
    DMS_SCREENSHOT_EDITOR = "swappy";
  };

  # Only start DMS when running under niri, not Plasma
  systemd.user.services.dms.Unit.ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";

  programs = {
    dank-material-shell = {
      enable = true;
      enableVPN = false;
      enableDynamicTheming = true;

      systemd = {
        enable = true;
        restartIfChanged = true;
      };

      niri = {
        enableKeybinds = false;
        enableSpawn = false;
      };

      plugins = {
        dankCalculator = {
          src = inputs.dank-calculator;
        };
        gpuScreenRecorder = {
          src = ./dms-plugins/gpu-screen-recorder;
        };
      };
    };

    nix-monitor = {
      enable = true;

      rebuildCommand = [
        "pkexec"
        "bash"
        "-c"
        "cd /home/${username}/nixos-config && sudo nixos-rebuild switch --flake .#desktop"
      ];

      generationsCommand = [
        "sh"
        "-c"
        "ls -d /nix/var/nix/profiles/system-*-link | wc -l"
      ];
    };

    niri.settings.binds = with config.lib.niri.actions; let
      dms-ipc = spawn "dms" "ipc";
    in {
      "Mod+Space" = {
        action = dms-ipc "spotlight" "toggle";
        hotkey-overlay.title = "Toggle Application Launcher";
      };
      "Mod+Y" = {
        action = dms-ipc "notifications" "toggle";
        hotkey-overlay.title = "Toggle Notification Center";
      };
      "Mod+Comma" = {
        action = dms-ipc "settings" "toggle";
        hotkey-overlay.title = "Toggle Settings";
      };
      "Mod+P" = {
        action = dms-ipc "notepad" "toggle";
        hotkey-overlay.title = "Toggle Notepad";
      };
      "Mod+S" = {
        action = dms-ipc "niri" "screenshot";
        hotkey-overlay.title = "Screenshot Region";
      };
      "Mod+Shift+S" = {
        action = dms-ipc "niri" "screenshotScreen";
        hotkey-overlay.title = "Screenshot Fullscreen";
      };
      "Mod+Alt+S" = {
        action = dms-ipc "niri" "screenshotWindow";
        hotkey-overlay.title = "Screenshot Window";
      };
      "Super+Alt+L" = {
        action = dms-ipc "lock" "lock";
        hotkey-overlay.title = "Toggle Lock Screen";
      };
      "Mod+X" = {
        action = dms-ipc "powermenu" "toggle";
        hotkey-overlay.title = "Toggle Power Menu";
      };
      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action = dms-ipc "audio" "increment" "3";
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action = dms-ipc "audio" "decrement" "3";
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action = dms-ipc "audio" "mute";
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action = dms-ipc "audio" "micmute";
      };
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action = dms-ipc "brightness" "increment" "5" "";
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action = dms-ipc "brightness" "decrement" "5" "";
      };
      "Mod+Alt+N" = {
        allow-when-locked = true;
        action = dms-ipc "night" "toggle";
        hotkey-overlay.title = "Toggle Night Mode";
      };
      "Mod+V" = {
        action = dms-ipc "clipboard" "toggle";
        hotkey-overlay.title = "Toggle Clipboard Manager";
      };
      "Mod+U" = {
        action = spawn "thunar";
        hotkey-overlay.title = "Open File Manager";
      };
    };
  };
}

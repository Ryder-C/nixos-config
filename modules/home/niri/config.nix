{
  inputs,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    grim
    slurp
    swappy
    xwayland-satellite
    inputs.librepods.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.niri.package = lib.mkForce pkgs.niri;

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
    DISABLE_QT5_COMPAT = "0";
    GDK_BACKEND = "wayland";
    ANKI_WAYLAND = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";

    # NVIDIA specifics
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  programs.niri.settings = {
    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;

    input = {
      keyboard = {
        xkb = {
          layout = "us,fr";
          options = "grp:alt_caps_toggle";
        };
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
      warp-mouse-to-focus.enable = false;
      focus-follows-mouse.enable = true;
    };

    outputs = {
      "DP-3" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 239.996;
        };
        scale = 1.5;
        variable-refresh-rate = false;
        position = {
          x = 0;
          y = 0;
        };
      };
      "DP-2" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 59.997;
        };
        scale = 1.5;
        position = {
          x = 2560;
          y = 0;
        };
      };
    };

    layout = {
      gaps = 4;
      center-focused-column = "never";
      preset-column-widths = [
        {proportion = 0.33333;}
        {proportion = 0.5;}
        {proportion = 0.66667;}
      ];
      default-column-width = {
        proportion = 0.5;
      };
      focus-ring = {
        enable = true;
        width = 2;
        active.color = "#cba6f7";
        inactive.color = "#45475a";
      };
      border = {
        enable = false;
      };
    };

    spawn-at-startup = [
      {
        command = [
          "systemctl"
          "--user"
          "import-environment"
        ];
      }
      {command = ["vesktop"];}
    ];

    binds = {
      "Mod+Shift+Slash".action.show-hotkey-overlay = {};
      "Mod+Return".action.spawn = ["alacritty"];
      "Mod+B".action.spawn = ["librewolf"];
      "Mod+D".action.spawn = ["vesktop"];

      "Mod+Q".action.close-window = {};

      # Colemak Focus
      "Mod+m".action.focus-column-left = {};
      "Mod+n".action.focus-window-down = {};
      "Mod+e".action.focus-window-up = {};
      "Mod+i".action.focus-column-right = {};

      # Colemak Move
      "Mod+Shift+m".action.move-column-left = {};
      "Mod+Shift+n".action.move-window-down = {};
      "Mod+Shift+e".action.move-window-up = {};
      "Mod+Shift+i".action.move-column-right = {};

      # Monitor Focus
      "Mod+Left".action.focus-monitor-left = {};
      "Mod+Right".action.focus-monitor-right = {};
      "Mod+Shift+Left".action.spawn = ["sh" "-c" "niri msg action move-window-to-monitor-left && niri msg action move-column-to-first"];
      "Mod+Shift+Right".action.spawn = ["sh" "-c" "niri msg action move-window-to-monitor-right && niri msg action move-column-to-first"];

      "Mod+C".action.center-column = {};

      # Workspaces
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;

      "Mod+O".action.toggle-overview = {};

      "Mod+F".action.maximize-column = {};
      "Mod+Shift+F".action.fullscreen-window = {};
      "Mod+Shift+Space".action.toggle-window-floating = {};

      "Mod+BracketLeft".action.consume-window-into-column = {};
      "Mod+BracketRight".action.expel-window-from-column = {};

      "Mod+Shift+Q".action.quit = {
        skip-confirmation = true;
      };

      # GPU Screen Recorder - Save Replay
      "Mod+Shift+R".action.spawn = ["sh" "-c" "killall -SIGUSR1 gpu-screen-recorder && notify-send 'Replay Saved' 'Saved to ~/Videos/'"];

      # Media Keys
      "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
      "XF86AudioNext".action.spawn = ["playerctl" "next"];
      "XF86AudioPrev".action.spawn = ["playerctl" "previous"];
    };
  };

  systemd.user.services.gpu-screen-recorder = {
    Unit = {
      Description = "GPU Screen Recorder - Replay Buffer";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w DP-3 -c mp4 -f 60 -a default_output -r 120 -o /home/ryder/Videos";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  systemd.user.services.librepods = {
    Unit = {
      Description = "LibrePods";
      After = ["graphical-session.target" "tray.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "${inputs.librepods.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/librepods --start-minimized";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}

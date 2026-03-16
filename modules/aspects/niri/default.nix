{inputs, ...}: {
  flake-file.inputs.niri.url = "github:sodiboo/niri-flake";

  ry.niri.homeManager = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.niri.homeModules.niri
      ./_idle.nix
      ./_window-rules.nix
    ];

    home.packages = with pkgs; [
      grim
      slurp
      swappy
      xwayland-satellite
    ];

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
    };

    programs.niri = {
      package = lib.mkForce pkgs.niri;
      enable = true;
      settings = {
        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;

        input = {
          mouse = {
            accel-profile = "flat";
          };
          keyboard.xkb = {
            layout = "us,fr";
            options = "grp:alt_caps_toggle";
          };
          touchpad = {
            tap = true;
            natural-scroll = true;
            scroll-factor = 0.5;
          };
          warp-mouse-to-focus.enable = false;
          focus-follows-mouse.enable = true;
          workspace-auto-back-and-forth = true;
        };

        layout = {
          gaps = 4;
          center-focused-column = "never";
          preset-column-widths = [
            {proportion = 0.33333;}
            {proportion = 0.5;}
            {proportion = 0.66667;}
          ];
          default-column-width.proportion = 0.5;
          border = {
            enable = true;
            width = 2;
            active.color = "#cba6f7";
            inactive.color = "#45475a";
          };
          focus-ring.enable = false;
          tab-indicator.place-within-column = true;
        };

        spawn-at-startup = [
          {
            command = [
              "systemctl"
              "--user"
              "import-environment"
            ];
          }
        ];

        binds = {
          "Mod+Shift+Slash".action.show-hotkey-overlay = {};
          "Mod+Return".action.spawn = ["alacritty"];
          "Mod+B".action.spawn = ["brave"];
          "Mod+D".action.spawn = ["vesktop"];

          "Mod+Q".action.close-window = {};

          "Mod+C".action.center-column = {};

          # Colemak Focus
          "Mod+m".action.focus-column-or-monitor-left = {};
          "Mod+n".action.focus-window-or-workspace-down = {};
          "Mod+e".action.focus-window-or-workspace-up = {};
          "Mod+i".action.focus-column-or-monitor-right = {};

          # Colemak Move
          "Mod+Shift+m".action.move-column-left-or-to-monitor-left = {};
          "Mod+Shift+n".action.move-window-down-or-to-workspace-down = {};
          "Mod+Shift+e".action.move-window-up-or-to-workspace-up = {};
          "Mod+Shift+i".action.move-column-right-or-to-monitor-right = {};

          # Colemak Consume/Expel - Move
          "Mod+Ctrl+m".action.consume-or-expel-window-left = {};
          "Mod+Ctrl+i".action.consume-or-expel-window-right = {};

          # Monitor Focus
          "Mod+Left".action.focus-monitor-left = {};
          "Mod+Right".action.focus-monitor-right = {};
          "Mod+Shift+Left".action.spawn = ["sh" "-c" "niri msg action move-window-to-monitor-left && niri msg action move-column-to-first"];
          "Mod+Shift+Right".action.spawn = ["sh" "-c" "niri msg action move-window-to-monitor-right && niri msg action move-column-to-first"];

          # Workspaces
          "Mod+Up".action.focus-workspace-up = {};
          "Mod+Down".action.focus-workspace-down = {};

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
          "Mod+W".action.toggle-column-tabbed-display = {};

          "Mod+F".action.maximize-column = {};
          "Mod+Ctrl+F".action.expand-column-to-available-width = {};
          "Mod+Shift+F".action.fullscreen-window = {};
          "Mod+Shift+Space".action.toggle-window-floating = {};

          "Mod+BracketLeft".action.consume-window-into-column = {};
          "Mod+BracketRight".action.expel-window-from-column = {};

          "Mod+Shift+Q".action.quit = {
            skip-confirmation = true;
          };

          # Media Keys
          "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
          "XF86AudioNext".action.spawn = ["playerctl" "next"];
          "XF86AudioPrev".action.spawn = ["playerctl" "previous"];

          # GPU Screen Recorder replay save
          "Mod+Shift+R".action.spawn = ["sh" "-c" "killall -SIGUSR1 gpu-screen-recorder && notify-send 'Replay Saved' 'Saved to ~/Videos/'"];
        };
      };
    };
  };

  ry.niri-desktop.homeManager = {
    programs.niri.settings = {
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
      spawn-at-startup = [
        {command = ["vesktop"];}
      ];
    };
  };

  ry.niri-laptop.homeManager = {
    programs.niri.settings = {
      debug.render-drm-device = "/dev/dri/renderD128";
      switch-events = {
        lid-close.action.spawn = ["sh" "-c" "niri msg action power-off-monitors"];
        lid-open.action.spawn = ["sh" "-c" "sleep 0.5 && niri msg action power-on-monitors"];
      };
      outputs = {
        "eDP-1" = {
          mode = {
            width = 3024;
            height = 1964;
            refresh = 120.000;
          };
          scale = 2.0;
        };
      };
    };
  };
}

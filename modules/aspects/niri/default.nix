{inputs, ...}: {
  flake-file.inputs.niri.url = "github:sodiboo/niri-flake";

  ry.niri = {
    nixos = {lib, ...}: {
      services.displayManager.defaultSession = lib.mkForce "niri";
    };
    homeManager = {
      pkgs,
      lib,
      ...
    }: {
      imports = [
        inputs.niri.homeModules.niri
        ./_window-rules.nix
      ];

      home.packages = with pkgs; [
        grim
        slurp
        swappy
        xwayland-satellite
      ];

      xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk];
        # niri implements screencast via org.gnome.Mutter.ScreenCast, so it
        # must go to xdp-gnome. xdp-wlr's screencopy path has no damage
        # tracking here, which niri treats as a one-off screenshot -- the
        # screenshare freezes on its first frame.
        config.niri = {
          default = ["gtk"];
          "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
          "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
        };
      };

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
              tap = false;
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
            "Mod+Return".action.spawn = ["ghostty" "+new-window"];
            "Mod+B".action.spawn = ["helium"];

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

            # Brightness Keys — brightnessctl directly; noctalia auto-shows OSD
            "XF86MonBrightnessUp" = {
              allow-when-locked = true;
              action.spawn = ["brightnessctl" "set" "5%+"];
            };
            "XF86MonBrightnessDown" = {
              allow-when-locked = true;
              action.spawn = ["brightnessctl" "set" "5%-"];
            };

            # Workspace/Mission Control key (Mac F3) opens niri overview
            "XF86LaunchA".action.toggle-overview = {};

            # Screenshots
            "Mod+S".action.screenshot = {};
            "Mod+Shift+S".action.screenshot-screen = {};
            "Mod+Alt+S".action.screenshot-window = {};
          };
        };
      };
    };
  };
}

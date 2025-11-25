{pkgs, ...}: let
  replay-script = pkgs.writeShellScript "replay-notify" ''
    #!/usr/bin/env bash
    pkill -SIGUSR1 -f gpu-screen-recorder && notify-send -u low "Replay saved" "$(date +%H:%M:%S)"
  '';
in {
  wayland.windowManager.hyprland = {
    settings = {
      # autostart
      exec-once = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &"
        "systemctl --user import-environment &"
        "hash dbus-update-activation-environment 2>/dev/null &"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &"
        "nm-applet &"
        "wl-clip-persist --clipboard both"
        "swaybg -m fill -i $(find ~/Pictures/wallpapers/ -maxdepth 1 -type f) &"
        "hyprctl setcursor Nordzy-cursors 22 &"
        "poweralertd &"
        # "swaync &"
        "wl-paste --watch cliphist store &"
        "hyprlock &"

        "[workspace 2 silent] vesktop"
      ];

      input = {
        kb_layout = "us,fr";
        kb_options = "grp:alt_caps_toggle";
        numlock_by_default = true;
        follow_mouse = 1;
        sensitivity = 0;
        # touchpad = {
        #   natural_scroll = true;
        # };
      };

      # device = {
      #   name = "wacom-intuos-pt-s-2-pen";
      #   output = "DP-5";
      # };

      cursor = {
        no_hardware_cursors = true;
      };

      general = {
        "$mainMod" = "SUPER";
        layout = "dwindle";
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;
        "col.active_border" = "rgb(cba6f7) rgb(94e2d5) 45deg";
        "col.inactive_border" = "rgb(45475a)";
        # border_part_of_window = false;
        # no_border_on_floating = false;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
      };

      dwindle = {
        # no_gaps_when_only = true;
        force_split = 0;
        special_scale_factor = 1.0;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        new_status = "master";
        special_scale_factor = 1;
        # no_gaps_when_only = false;
      };

      decoration = {
        rounding = 10;
        # active_opacity = 0.90;
        # inactive_opacity = 0.90;
        # fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 1;
          passes = 1;
          # size = 4;
          # passes = 2;
          brightness = 1;
          contrast = 1.400;
          ignore_opacity = true;
          noise = 0;
          new_optimizations = true;
          xray = true;
        };

        # drop_shadow = true;

        # shadow_ignore_window = true;
        # shadow_offset = "0 2";
        # shadow_range = 20;
        # shadow_render_power = 3;
        # "col.shadow" = "rgba(00000055)";
      };

      animations = {
        enabled = true;

        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeinoutsine, 0.37, 0, 0.63, 1"
        ];

        animation = [
          # Windows
          "windowsIn, 1, 3, easeOutCubic, popin 30%" # window open
          "windowsOut, 1, 3, fluent_decel, popin 70%" # window close.
          "windowsMove, 1, 2, easeinoutsine, slide" # everything in between, moving, dragging, resizing.

          # Fade
          "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
          "fadeOut, 1, 2, easeOutCubic" # fade out (close) -> layers and windows
          "fadeSwitch, 0, 1, easeOutCirc" # fade on changing activewindow and its opacity
          "fadeShadow, 1, 10, easeOutCirc" # fade on changing activewindow for shadows
          "fadeDim, 1, 4, fluent_decel" # the easing of the dimming of inactive windows
          "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
          "borderangle, 1, 30, fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
          "workspaces, 1, 4, easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
        ];
      };

      bind = [
        # show keybinds list
        "$mainMod, F1, exec, show-keybinds"

        # keybindings
        "$mainMod, Return, exec, alacritty"
        "ALT, Return, exec, alacritty --title float_alacritty"
        "$mainMod SHIFT, Return, exec, alacritty --start-as=fullscreen -o 'font_size=16'"
        "$mainMod, B, exec, zen"
        "$mainMod, Q, killactive,"
        "$mainMod, F, fullscreen, 0"
        "$mainMod SHIFT, F, fullscreen, 1"
        "$mainMod, Space, togglefloating,"
        "$mainMod, D, exec, fuzzel"
        "$mainMod, G, exec, fuzzel-steam-games"
        "$mainMod SHIFT, D, exec, vesktop"
        "$mainMod SHIFT, S, exec, spotify"
        "$mainMod, Escape, exec, swaylock"
        "$mainMod SHIFT, Escape, exec, shutdown-script"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, U, exec, nautilus"
        "$mainMod SHIFT, B, exec, pkill -SIGUSR1 .waybar-wrapped"
        "$mainMod, C ,exec, hyprpicker -a"
        "$mainMod, W,exec, wallpaper-picker"
        "$mainMod SHIFT, W, exec, vm-start"

        # screenshot
        # "$mainMod, Print, exec, grimblast --notify --cursor --freeze save area ~/Pictures/$(date +'%Y-%m-%d-At-%Ih%Mm%Ss').png"
        # ",Print, exec, grimblast --notify --cursor --freeze copy area"
        "$mainMod SHIFT, P, exec, hyprshot --raw -m region - | swappy -f -"
        "$mainMod CTRL, P, exec, hyprshot --raw -m window - | swappy -f -"
        "$mainMod ALT, P, exec, hyprshot --raw -m output - | swappy -f -"

        # replay
        "SHIFT, F8, exec, ${replay-script}"

        # switch focus
        "$mainMod, m, movefocus, l"
        "$mainMod, i, movefocus, r"
        "$mainMod, e, movefocus, u"
        "$mainMod, n, movefocus, d"

        # switch workspace
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # same as above, but switch to the workspace
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1" # movetoworkspacesilent
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        "$mainMod CTRL, c, movetoworkspace, empty"

        # window control
        "$mainMod SHIFT, m, movewindow, l"
        "$mainMod SHIFT, i, movewindow, r"
        "$mainMod SHIFT, e, movewindow, u"
        "$mainMod SHIFT, n, movewindow, d"
        "$mainMod CTRL, m, resizeactive, -80 0"
        "$mainMod CTRL, i, resizeactive, 80 0"
        "$mainMod CTRL, n, resizeactive, 0 -80"
        "$mainMod CTRL, e, resizeactive, 0 80"
        "$mainMod ALT, m, moveactive,  -80 0"
        "$mainMod ALT, i, moveactive, 80 0"
        "$mainMod ALT, n, moveactive, 0 -80"
        "$mainMod ALT, e, moveactive, 0 80"

        # media and volume controls
        ",XF86AudioRaiseVolume,exec, pamixer -i 2"
        ",XF86AudioLowerVolume,exec, pamixer -d 2"
        ",XF86AudioMute,exec, pamixer -t"
        ",XF86AudioPlay,exec, playerctl play-pause"
        ",XF86AudioNext,exec, playerctl next"
        ",XF86AudioPrev,exec, playerctl previous"
        ",XF86AudioStop, exec, playerctl stop"
        "$mainMod, mouse_down, workspace, e-1"
        "$mainMod, mouse_up, workspace, e+1"

        # laptop brigthness
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        "$mainMod, XF86MonBrightnessUp, exec, brightnessctl set 100%+"
        "$mainMod, XF86MonBrightnessDown, exec, brightnessctl set 100%-"

        # clipboard manager
        "$mainMod, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
      ];

      # mouse binding
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # windowrule (formerly windowrulev2)
      windowrule = [
        "float 1, match:class ^(imv)$"
        "center 1, match:class ^(imv)$"
        "size 1200 725, match:class ^(imv)$"

        "float 1, match:class ^(mpv)$"
        "center 1, match:class ^(mpv)$"
        "size 1200 725, match:class ^(mpv)$"

        "float 1, match:class ^(blueman-manager)$"
        "center 1, match:class ^(blueman-manager)$"
        "size 700 450, match:class ^(blueman-manager)$"

        "tile 1, match:class ^(Aseprite)$"

        "float 1, match:title ^(float_alacritty)$"
        "center 1, match:title ^(float_alacritty)$"
        "size 950 600, match:title ^(float_alacritty)$"

        "float 1, match:class ^(audacious)$"

        "tile 1, match:class ^(neovide)$"

        # FIXED: idleinhibit -> idle_inhibit
        "idle_inhibit focus, match:class ^(mpv)$"
        "idle_inhibit focus, match:class ^(com.github.iwalton3.jellyfin-media-player)$"
        "idle_inhibit focus, match:class ^(Plex)$"

        "float 1, match:class ^(udiskie)$"

        "float 1, match:title ^(Transmission)$"

        "float 1, match:title ^(Volume Control)$"
        "size 700 450, match:title ^(Volume Control)$"
        "move 40 55%, match:title ^(Volume Control)$"

        "float 1, match:title ^(Firefox — Sharing Indicator)$"
        "move 0 0, match:title ^(Firefox — Sharing Indicator)$"

        "float 1, match:title ^(Picture-in-Picture)$"
        "opacity 1.0 override 1.0 override, match:title ^(Picture-in-Picture)$"
        "pin 1, match:title ^(Picture-in-Picture)$"

        "opacity 1.0 override 1.0 override, match:title ^(.*imv.*)$"
        "opacity 1.0 override 1.0 override, match:title ^(.*mpv.*)$"
        "opacity 1.0 override 1.0 override, match:class (Aseprite)"
        "opacity 1.0 override 1.0 override, match:class (Unity)"

        # FIXED: idleinhibit -> idle_inhibit
        "idle_inhibit focus, match:class ^(mpv)$"
        "idle_inhibit fullscreen, match:class ^(firefox)$"

        "float 1, match:class ^(zenity)$"
        "center 1, match:class ^(zenity)$"
        "size 850 500, match:class ^(zenity)$"

        "float 1, match:class ^(pavucontrol)$"
        "float 1, match:class ^(SoundWireServer)$"
        "float 1, match:class ^(.sameboy-wrapped)$"
        "float 1, match:class ^(file_progress)$"
        "float 1, match:class ^(confirm)$"
        "float 1, match:class ^(dialog)$"
        "float 1, match:class ^(download)$"
        "float 1, match:class ^(notification)$"
        "float 1, match:class ^(error)$"
        "float 1, match:class ^(confirmreset)$"
        "float 1, match:title ^(Open File)$"
        "float 1, match:title ^(branchdialog)$"
        "float 1, match:title ^(Confirm to replace files)$"
        "float 1, match:title ^(File Operation Progress)$"

        "opacity 0.0 override, match:class ^(xwaylandvideobridge)$"

        # FIXED: noanim -> no_anim
        "no_anim 1, match:class ^(xwaylandvideobridge)$"
        # FIXED: noinitialfocus -> no_initial_focus
        "no_initial_focus 1, match:class ^(xwaylandvideobridge)$"
        "max_size 1 1, match:class ^(xwaylandvideobridge)$"
        # FIXED: noblur -> no_blur
        "no_blur 1, match:class ^(xwaylandvideobridge)$"
      ];
    };

    extraConfig = "
      monitor=DP-5, 1920x1080@240, 0x0, 1
      # monitor=DP-4, 3840x2160@60, -3840x-540, 1, bitdepth, 10
      monitor=HDMI-A-2, 1920x1080@144, 1920x0, 1

      monitor=Unknown-1, disable

      workspace=1, monitor:DP-5
      workspace=2, monitor:HDMI-A-2
      # workspace=3, monitor:DP-4

      xwayland {
        force_zero_scaling = true
      }

      debug:full_cm_proto = true
    ";
  };
}

{
  inputs,
  ry,
  ...
}: {
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia-shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  ry = {
    noctalia.nixos = {pkgs, ...}: {
      nix.settings = {
        substituters = ["https://noctalia.cachix.org"];
        trusted-public-keys = ["noctalia.cachix.org-1:X+I9x9j4W6h6q5lG2G8uX+5f6L2yU8K5o9y9U+L6J9o="];
      };

      # Lets the drive-health plugin read SMART as the session user, instead of
      # the plugin's own route of pkexec-installing a root collector into
      # /usr/local (which does not exist on NixOS).
      #
      # Each capability is load-bearing:
      #   dac_override  open /dev/nvme0, which is 0600 root:root
      #   sys_admin     the NVMe admin passthrough ioctl
      #   sys_rawio     SCSI/ATA SG_IO on /dev/sd*
      #
      # NOTE: dac_override + sys_admin on a binary every local user can exec is
      # root-equivalent in practice. This is the cost of reading SMART without
      # a privileged collector; see the drive-health notes if that trade stops
      # being acceptable.
      security.wrappers.smartctl = {
        source = "${pkgs.smartmontools}/bin/smartctl";
        owner = "root";
        group = "root";
        capabilities = "cap_dac_override,cap_sys_rawio,cap_sys_admin+ep";
      };
    };

    noctalia.homeManager = {
      config,
      lib,
      pkgs,
      ...
    }: let
      niriEnabled = config.programs.niri.enable;
      noctaliaPkg = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in {
      imports = [inputs.noctalia.homeModules.default];

      # smartctl for the drive-health plugin is *not* listed here on purpose:
      # it comes from security.wrappers above, so the only smartctl on PATH is
      # the capability-carrying one. A plain copy here would sit in
      # ~/.nix-profile/bin, which loses to /run/wrappers/bin, and would quietly
      # take over as a permission-denied stub if the wrapper ever went away.
      home.packages = with pkgs; [
        satty
        fastfetch
      ];

      programs.noctalia = {
        enable = true;
        package = noctaliaPkg;

        settings = {
          shell = {
            polkit_agent = true;
            avatar_path = "${config.home.homeDirectory}/.face";
            corner_radius_scale = 1.0;
            clipboard_enabled = true;
            niri_overview_type_to_launch_enabled = true;
            settings_show_advanced = true;
            screenshot = {
              pipe_to_command = true;
              pipe_command = "satty -f -";
            };
          };

          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Catppuccin";
          };

          weather = {
            enabled = true;
            unit = "imperial";
          };

          location = {
            auto_locate = true;
            address = "Cardiff by the Sea, United States";
          };

          wallpaper = {
            enabled = true;
            directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
            transition_on_startup = true;
            automation = {
              enabled = false;
              order = "random";
              recursive = true;
            };
          };

          system.monitor.enabled = true;

          idle.behavior = {
            lock = {
              timeout = 600;
              enabled = true;
              action = "lock";
            };
            "screen-off" = {
              timeout = 330;
              enabled = true;
              action = "screen_off";
            };
            "rgb-off" = {
              timeout = 330;
              command = "openrgb -p off";
              resume_command = "openrgb -p main";
              enabled = true;
            };
          };

          bar.main = {
            position = "top";
            background_opacity = 0.93;
            capsule = true;
            margin_edge = 0;
            margin_ends = 0;
            padding = 7;
            radius = 0;
            start = ["control-center" "workspaces" "sysmon_cpu" "nix-monitor" "summary"];
            center = ["clock_date" "clock_time" "weather"];
            end = ["recorder" "tray" "network" "bluetooth" "notifications"];
          };

          # Plugin code is still cloned/updated by noctalia itself into
          # ~/.local/state/noctalia/plugins from the default official/community
          # git sources. Only which plugins are on, and how they are configured,
          # is declared here.
          plugins = {
            enabled = [
              "noctalia/screen_recorder"
              "noctalia/bitwarden"
              "avivbintangaringga/nix-monitor"
              "gustav0ar/drive-health"
            ];
            auto_update = true;
          };

          plugin_settings."noctalia/screen_recorder" = {
            replay_enabled = true;
            replay_duration = 60;
            # Reuse the saved xdg-desktop-portal session so the unattended
            # replay-buffer autostart does not raise a screen picker on login.
            restore_portal = true;

            # Separate audio tracks in the saved clip:
            #   1 game only   2 Discord   3 Spotify   4 mic
            # Game audio leads so that players and uploads which read just the
            # first audio track -- Discord, browser previews -- get the game
            # with no chat or music over it, which is what a highlight wants.
            #
            # There is deliberately no `default_output` mix track: these four
            # already partition everything audible, so a mix track would only
            # duplicate them. Restoring the combined sound therefore means
            # unmuting the other tracks in an editor.
            #
            # Track 1 is what makes a highlight editable at all, and a mix track
            # could not substitute for it: `default_output` is the device
            # monitor, so it contains Discord and Spotify too and muting the app
            # tracks subtracts nothing from it. Only an app-inverse source
            # yields game-without-chat, and stacking two exclusions in one
            # source is what excludes both apps at once -- measured faithful to
            # within 1 dB of the device monitor's level. Its quotes are
            # load-bearing: the value is spliced into a shell command line,
            # where a bare `|` would be a pipe.
            #
            # gpu-screen-recorder makes one track per `-a`, but the plugin only
            # ever emits one: audio_source is a 4-option select spliced into the
            # command line *unquoted* (`-a {source}`, see buildAudioFlags in
            # recorder_service.luau), so extra flags hidden in the value become
            # extra tracks. Short of forking the plugin this is the only lever;
            # if a plugin update starts validating or quoting audio_source this
            # silently collapses back to one track -- check the running process
            # args, not just the file, after a noctalia bump.
            #
            # App names are matched case-insensitively against whatever
            # `gpu-screen-recorder --list-application-audio` prints while the
            # app is playing. Naming an app that is not running yet is
            # supported and is the normal case for a login-armed buffer.
            audio_source = ''"app-inverse:Discord|app-inverse:Spotify" -a app:Discord -a app:Spotify -a default_input'';
          };

          widget = {
            "control-center" = {
              glyph = "snowflake";
            };
            workspaces = {
              type = "workspaces";
              show_labels = false;
            };
            sysmon_cpu = {
              type = "sysmon";
              stat = "cpu_usage";
            };
            clock_date = {
              type = "clock";
              format = "{:%a, %b %d}";
            };
            clock_time = {
              type = "clock";
              format = "{:%-I:%M %p}";
            };
            network = {
              type = "network";
              show_label = false;
            };
            bluetooth = {
              type = "bluetooth";
              show_label = false;
            };
            tray = {
              type = "tray";
              pinned = ["Battery Status"];
            };

            # Plugin-provided widgets.
            nix-monitor.type = "avivbintangaringga/nix-monitor:nix-monitor";
            summary.type = "gustav0ar/drive-health:summary";

            recorder = {
              type = "noctalia/screen_recorder:recorder";
              # Left click normally toggles a full recording; rebind it so the
              # only thing the bar icon does is flush the replay buffer to disk.
              # A config `actions` table wins over the widget's own handler.
              actions.left = "plugin noctalia/screen_recorder:service all replay-save";
            };
          };
        };
      };

      # Niri-specific integration
      programs.niri.settings = lib.mkIf niriEnabled {
        spawn-at-startup = lib.mkAfter [
          {command = ["noctalia"];}
        ];

        binds = let
          msg = ["noctalia" "msg"];
        in {
          "Mod+Space" = {
            action.spawn = msg ++ ["panel-toggle" "launcher"];
            hotkey-overlay.title = "Toggle Application Launcher";
          };
          "Mod+Y" = {
            action.spawn = msg ++ ["panel-toggle" "control-center" "notifications"];
            hotkey-overlay.title = "Toggle Notifications";
          };
          "Mod+Comma" = {
            action.spawn = msg ++ ["settings-toggle"];
            hotkey-overlay.title = "Toggle Settings";
          };
          "Mod+X" = {
            action.spawn = msg ++ ["panel-toggle" "session"];
            hotkey-overlay.title = "Toggle Power Menu";
          };
          "Mod+V" = {
            action.spawn = msg ++ ["panel-toggle" "clipboard"];
            hotkey-overlay.title = "Toggle Clipboard Manager";
          };

          # Volume Keys (via noctalia for OSD)
          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn = msg ++ ["volume-up"];
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn = msg ++ ["volume-down"];
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action.spawn = msg ++ ["volume-mute"];
          };

          # Search key (Mac F4) opens the launcher
          "XF86Search".action.spawn = msg ++ ["panel-toggle" "launcher"];
        };

        layer-rules = [
          {
            matches = [{namespace = "^noctalia-notification";}];
            block-out-from = "screen-capture";
          }
        ];
      };
    };

    noctalia-praxis = {
      includes = [ry.gpu-screen-recorder];

      nixos = {
        # Both portal units ship with an empty WantedBy, so they are purely
        # D-Bus activated and nothing has started them yet at login. The
        # screen_recorder plugin will not arm the replay buffer unless it can
        # *see* both processes running (it scans /proc), and it aborts before
        # issuing the portal request that would have activated them -- so this
        # is a deadlock, not just a race. Pull them into the graphical session.
        systemd.user.services.xdg-desktop-portal = {
          overrideStrategy = "asDropin";
          wantedBy = ["graphical-session.target"];
        };
        systemd.user.services.xdg-desktop-portal-gnome = {
          overrideStrategy = "asDropin";
          wantedBy = ["graphical-session.target"];
        };
      };

      homeManager = {
        config,
        lib,
        ...
      }: {
        # Arm the replay buffer for the whole session. The buffer only ever
        # writes a file when something asks it to (the bar icon, via
        # replay-save) -- stopping it, logging out or powering off just drops
        # the ring buffer, so nothing is saved implicitly.
        #
        # Retry until the buffer is actually up, not until the message is
        # accepted: `msg` succeeds as soon as the plugin service loads, but
        # replay-start still fails silently afterwards if the portal is not
        # ready yet, so keying off its exit status gives a false positive.
        # Poll for the gpu-screen-recorder replay process instead. replay-start
        # is a no-op unless the recorder is idle, so extra attempts are free.
        #
        # The pattern is spelled `...recorde[r]` so that pgrep does not match
        # this very shell, whose own command line contains the pattern.
        programs.noctalia.settings.hooks.started = let
          noctalia = lib.getExe config.programs.noctalia.package;
        in "i=0; while [ $i -lt 30 ]; do pgrep -f 'gpu-screen-recorde[r].*-r ' >/dev/null 2>&1 && break; ${noctalia} msg plugin noctalia/screen_recorder:service all replay-start >/dev/null 2>&1; i=$((i+1)); sleep 2; done";
      };
    };

    noctalia-sputnik = {
      homeManager = {lib, ...}: {
        programs.noctalia.settings.bar.main = {
          start = lib.mkForce ["control-center" "workspaces" "clock_date" "weather" "clock_time"];
          center = lib.mkForce [];
          end = lib.mkForce ["tray" "network" "bluetooth" "notifications" "battery_graphic"];
        };
        programs.noctalia.settings.widget.battery_graphic = {
          type = "battery";
          display_mode = "graphic";
        };
      };
    };
  };
}

_: {
  ry.terminal.homeManager = {
    config,
    pkgs,
    lib,
    isLinux,
    ...
  }: {
    programs.ghostty = {
      enable = true;
      # nixpkgs' ghostty is Linux-only; on darwin HM still writes the config
      # for a Ghostty installed outside Nix.
      package = lib.mkIf (!isLinux) null;
      settings =
        {
          background-opacity = 0.8;
          window-padding-x = 5;
          window-padding-y = 5;

          # No size overlay on every resize.
          resize-overlay = "never";

          # Keep a warm instance so `ghostty +new-window` is instant instead of
          # paying Ghostty's ~0.5s cold start on every window.
          quit-after-last-window-closed = false;

          # Mod+Q should just close the window, like it did with Alacritty.
          confirm-close-surface = false;

          font-family = "FiraCode Nerd Font";
          font-style = "Regular";

          # Equivalent of Alacritty's `terminal.osc52 = "CopyPaste"`.
          clipboard-read = "allow";
          clipboard-write = "allow";
        }
        // lib.optionalAttrs isLinux {
          bell-features = "audio";
          bell-audio-path = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/window-attention.oga";
        };
    };

    # `ghostty +new-window` needs either a live instance or a D-Bus-activatable
    # name. dbus-broker only scans activation files at its own startup, so a
    # session bus older than the Ghostty install can never activate it and the
    # keybind silently does nothing. Start the daemon with the graphical session
    # instead; this is the symlink `systemctl --user enable` would write.
    xdg.configFile = lib.mkIf isLinux {
      "systemd/user/graphical-session.target.wants/app-com.mitchellh.ghostty.service".source =
        "${config.programs.ghostty.package}/share/systemd/user/app-com.mitchellh.ghostty.service";
    };

    programs.zellij = {
      enable = true;
      settings = {
        session_serialization = false;
      };
    };
  };
}

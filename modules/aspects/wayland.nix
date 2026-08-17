_: {
  ry.wayland.nixos = {pkgs, ...}: {
    programs.niri.enable = true;
    services.libinput.enable = true;

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    # xdgOpenUsePortal makes the portal resolve and launch default handlers
    # itself. GLib drops any desktop entry whose Exec argv[0] isn't on PATH, and
    # these units only inherit systemd's minimal environment -- so apps with a
    # bare Exec (helium, tor-browser) vanished and links fell through to brave.
    # Give the portal the session PATH.
    systemd.user.services = let
      sessionPath = {
        overrideStrategy = "asDropin";
        serviceConfig.Environment = [
          ("PATH="
            + builtins.concatStringsSep ":" [
              "/run/wrappers/bin"
              "%h/.nix-profile/bin"
              "/nix/profile/bin"
              "%h/.local/state/nix/profile/bin"
              "/etc/profiles/per-user/%u/bin"
              "/nix/var/nix/profiles/default/bin"
              "/run/current-system/sw/bin"
            ])
        ];
      };
    in {
      xdg-desktop-portal = sessionPath;
      xdg-desktop-portal-gtk = sessionPath;
      xdg-desktop-portal-gnome = sessionPath;
    };

    environment.systemPackages = with pkgs; [
      xwayland
    ];
  };
}

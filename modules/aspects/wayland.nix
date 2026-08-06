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

    # xdgOpenUsePortal routes every xdg-open (and every Electron
    # shell.openExternal) through the portal, which resolves and launches the
    # default handler itself. GLib silently discards any desktop entry whose
    # Exec argv[0] is not on PATH, and these units otherwise inherit only
    # systemd's minimal DefaultEnvironment -- so entries with a bare Exec
    # (helium, tor-browser) vanished from the portal's registry and links fell
    # through to whichever browser ships an absolute Exec (brave). Hand the
    # portal the session PATH so it sees the same apps the session does; these
    # mirror the profile dirs already present in its XDG_DATA_DIRS.
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

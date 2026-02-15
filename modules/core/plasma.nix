{pkgs, ...}: {
  services = {
    desktopManager.plasma6.enable = true;

    # Disable Discover and PackageKit — updates are managed by Nix
    packagekit.enable = false;

    # Plasma6 module sets services.xserver.enable = mkDefault true,
    # which adds a Plasma X11 session. Disable it since we're Wayland-only.
    xserver.enable = false;

    # Ensure niri remains the default session
    displayManager.defaultSession = "niri";
  };

  environment = {
    etc."xdg/kwalletrc".text = ''
      [Wallet]
      Enabled=false
    '';

    # Disable KWallet so gnome-keyring handles secrets in both sessions.
    # This keeps browser logins/passwords consistent between niri and Plasma.
    sessionVariables.KWALLETD_ENABLED = "false";

    plasma6.excludePackages = with pkgs.kdePackages; [
      discover
    ];
  };
}

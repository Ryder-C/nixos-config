{pkgs, ...}: {
  services = {
    desktopManager.plasma6.enable = true;
    packagekit.enable = false;
    xserver.enable = false;
    displayManager.defaultSession = "niri";
  };

  environment = {
    etc."xdg/kwalletrc".text = ''
      [Wallet]
      Enabled=false
    '';
    sessionVariables.KWALLETD_ENABLED = "false";
    plasma6.excludePackages = with pkgs.kdePackages; [
      discover
    ];
  };
}

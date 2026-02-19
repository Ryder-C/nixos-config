{pkgs, ...}: {
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

  environment.systemPackages = with pkgs; [
    xwayland
  ];
}

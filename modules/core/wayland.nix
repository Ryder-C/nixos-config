{pkgs, ...}: {
  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  environment.systemPackages = with pkgs; [
    kdePackages.xwaylandvideobridge
    xwayland
  ];
}

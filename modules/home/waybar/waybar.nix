{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.override {
      pipewireSupport = true;
      cavaSupport = true;
    };
  };
}

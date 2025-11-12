{pkgs, ...}: {
  services.mako = {
    enable = true;
    extraConfig = ''
      default-timeout=5000
    '';
  };
}

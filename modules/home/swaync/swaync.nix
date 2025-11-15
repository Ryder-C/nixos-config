{pkgs, ...}: {
  services.mako = {
    enable = true;
    extraConfig = ''
      default-timeout=5000

      group-by=app-name
    '';
  };
}

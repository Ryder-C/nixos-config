{pkgs, host, lib, ...}: {
  programs.btop = {
    enable = true;
    package = if host != "laptop" then pkgs.btop-cuda else pkgs.btop;

    settings = {
      theme_background = false;
      update_ms = 500;
    };
  };

  home.packages = lib.optionals (host != "laptop") [pkgs.nvtopPackages.nvidia];
}

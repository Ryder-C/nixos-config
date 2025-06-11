{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop-cuda;

    settings = {
      theme_background = false;
      update_ms = 500;
    };
  };

  home.packages = with pkgs; [nvtopPackages.nvidia];
}

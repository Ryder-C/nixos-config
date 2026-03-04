_: {
  ry.nvidia = {
    nixos = {config, ...}: {
      services.xserver.videoDrivers = ["nvidia"];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };

      boot.kernelParams = [
        "nvidia-drm.modeset=1"
        "nvidia-drm.fbdev=1"
      ];

      nixpkgs.overlays = [
        (final: prev: {
          btop = prev.btop.override {cudaSupport = true;};
          blender = prev.blender.override {cudaSupport = true;};
        })
      ];
    };

    homeManager = {pkgs, ...}: {
      home.packages = [ pkgs.nvtopPackages.nvidia ];
    };
  };
}

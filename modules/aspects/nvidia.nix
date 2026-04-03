{inputs, ...}: let
  cudaOverlay = _final: prev: {
    btop = prev.btop.override {cudaSupport = true;};
    blender = prev.blender.override {cudaSupport = true;};
  };
in {
  ry.nvidia = {
    nixos = {
      config,
      lib,
      pkgs,
      ...
    }: {
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

      _module.args.stablePkgs = lib.mkForce (import inputs.nixpkgs-stable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
        overlays = [cudaOverlay];
      });

      nixpkgs.overlays = [cudaOverlay];
    };

    homeManager = {
      lib,
      pkgs,
      ...
    }: {
      _module.args.stablePkgs = lib.mkForce (import inputs.nixpkgs-stable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
        overlays = [cudaOverlay];
      });
      home.packages = [pkgs.nvtopPackages.nvidia];
    };
  };
}

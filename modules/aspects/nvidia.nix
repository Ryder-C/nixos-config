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

      environment.sessionVariables = {
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
        __GL_VRR_ALLOWED = "0";
      };

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

      xdg.desktopEntries.vesktop = {
        name = "Vesktop";
        genericName = "Internet Messenger";
        exec = "vesktop --enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,VaapiIgnoreDriverChecks,VaapiOnNvidiaGPUs --ignore-gpu-blocklist --enable-zero-copy %U";
        icon = "vesktop";
        categories = ["Network" "InstantMessaging" "Chat"];
        mimeType = ["x-scheme-handler/discord"];
        settings.StartupWMClass = "Vesktop";
      };
    };
  };
}

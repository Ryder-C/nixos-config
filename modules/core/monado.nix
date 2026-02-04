{pkgs, ...}: {
  # Enable the Monado service and register it as the default OpenXR runtime
  services.monado = {
    enable = true;
    defaultRuntime = true;
  };

  # Environment variables for improved hand tracking on Rift S
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
    AEG_USE_DYNAMIC_RANGE = "true";
  };

  # Ensure git-lfs is enabled to download hand-tracking models
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # Install Monado package
  environment.systemPackages = with pkgs; [monado];
}

_: {
  ry.monado.nixos = {config, pkgs, lib, ...}:
    lib.mkIf config._ry.isX86 {
    services.monado = {
      enable = true;
      defaultRuntime = true;
    };

    systemd.user.services.monado.environment = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      AEG_USE_DYNAMIC_RANGE = "true";
    };

    programs.git = {
      enable = true;
      lfs.enable = true;
    };

    environment.systemPackages = with pkgs; [monado];
  };
}

{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
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

  # Post-install activation script to clone hand-tracking models
  # system.activationScripts.monado-handtracking-models = {
  #   text = ''
  #     #!${pkgs.runtimeShell}
  #     mkdir -p /home/${username}/.local/share/monado
  #     if [ ! -d /home/${username}/.local/share/monado/hand-tracking-models ]; then
  #       ${pkgs.git}/bin/git clone https://gitlab.freedesktop.org/monado/utilities/hand-tracking-models \
  #         /home/${username}/.local/share/monado/hand-tracking-models
  #       chown -R ${username}:users /home/${username}/.local/share/monado
  #     fi
  #   '';
  #   deps = [pkgs.git pkgs.git-lfs];
  # };
}

{
  ry.cosmic.nixos = {
    # environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    services = {
      desktopManager.cosmic = {
        enable = true;
        xwayland.enable = true;
      };
      system76-scheduler.enable = true;
    };
  };
}

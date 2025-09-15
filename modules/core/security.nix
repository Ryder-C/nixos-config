_: {
  security = {
    rtkit.enable = true;
    sudo.enable = true;
    polkit.enable = true;
  };
  # security.pam.services.swaylock = { };
  security.pam.services.hyprlock = {};
}

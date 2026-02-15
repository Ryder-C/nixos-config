_: {
  security = {
    rtkit.enable = true;
    sudo.enable = true;
    polkit.enable = true;
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.greetd.enableKwallet = false;
}

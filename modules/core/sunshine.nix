_: {
  services = {
    sunshine = {
      enable = true;
      autoStart = false;
      openFirewall = true;
      capSysAdmin = true;
    };
    tailscale = {
      enable = true;
      openFirewall = true;
    };
  };
}

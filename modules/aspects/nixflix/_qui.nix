{config, ...}: {
  services.qui = {
    enable = true;
    secretFile = config.age.secrets.qui.path;
    settings.host = "0.0.0.0";
  };
}

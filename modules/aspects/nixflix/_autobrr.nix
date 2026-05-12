{config, ...}: {
  services.autobrr = {
    enable = true;
    openFirewall = true;
    settings = {
      host = "0.0.0.0";
      logLevel = "DEBUG";
    };
    secretFile = config.age.secrets.autobrr.path;
  };

  ry.homepage.services."Downloads" = [
    {
      "Autobrr" = {
        href = "http://${config.networking.hostName}:7474";
        icon = "autobrr";
        widget = {
          type = "autobrr";
          url = "http://localhost:7474";
          key = "976f0d8683880823d9d3ea43ab1792af";
        };
      };
    }
  ];
}

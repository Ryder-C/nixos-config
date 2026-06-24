{config, ...}: {
  services.bazarr = {
    enable = true;
    group = "media";
    dataDir = "/storage/.state/bazarr";
  };

  ry.homepage.services."Arr" = [
    {
      "Bazarr" = {
        href = "http://${config.networking.hostName}:6767";
        icon = "bazarr";
        widget = {
          type = "bazarr";
          url = "http://localhost:6767";
          key = "7556d85e574df4f87e8117608a75ba94";
        };
      };
    }
  ];
}

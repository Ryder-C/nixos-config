{
  ry.uptime-kuma.nixos = {
    ry.caddy.vhosts."ryder.rs".status = 3002;

    services.uptime-kuma = {
      enable = true;
      settings.PORT = "3002";
    };

    ry.homepage.services."Monitoring" = [
      {
        "Uptime Kuma" = {
          href = "https://status.ryder.rs";
          icon = "uptime-kuma";
          widget = {
            type = "uptimekuma";
            url = "http://localhost:3002";
            slug = "default";
          };
        };
      }
    ];
  };
}

{
  ry.homepage.nixos = {config, ...}: {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      allowedHosts = "${config.networking.hostName}.stork-mulley.ts.net:8082";

      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/storage";
            expanded = true;
          };
        }
        {
          datetime = {
            text_size = "xl";
            format = {
              dateStyle = "long";
              timeStyle = "short";
              hourCycle = "h23";
            };
          };
        }
      ];

      # Service entries are contributed by their owning aspects via
      # services.homepage-dashboard.services, so each tile only appears
      # when both ry.homepage and the source aspect are included.
    };
  };
}

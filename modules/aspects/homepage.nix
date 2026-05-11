{
  ry.homepage.nixos = {
    config,
    lib,
    ...
  }: {
    options.ry.homepage.services = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.anything);
      default = {};
      description = "Map of group name to list of homepage service entries";
    };

    config.services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      allowedHosts = "${config.networking.hostName}:8082";

      services = lib.mapAttrsToList (group: entries: {"${group}" = entries;}) config.ry.homepage.services;

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
    };
  };
}

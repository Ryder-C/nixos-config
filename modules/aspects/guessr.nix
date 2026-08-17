{inputs, ...}: {
  flake-file.inputs.ryguessr.url = "github:AdinAck/ryguessr";

  ry.guessr.nixos = {config, ...}: {
    imports = [inputs.ryguessr.nixosModules.default];

    ry.caddy.vhosts."ryder.rs".guessr = 3000;

    age.secrets.google-maps = {
      file = ../../secrets/google-maps.age;
    };

    services.ryguessr = {
      enable = true;
      googleMapsApiKeyFile = config.age.secrets.google-maps.path;
      bindAddr = "127.0.0.1:3000";
    };
  };
}

{
  inputs,
  username,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];

  age = {
    identityPaths = ["/home/ryder/.ssh/id_ed25519"];
    secrets = {
      pia.file = ../../secrets/pia.age;
      steam_key = {
        file = ../../secrets/steam_key.age;
        owner = "${username}";
        mode = "0400";
      };
    };
  };
}

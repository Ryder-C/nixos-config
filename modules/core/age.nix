{inputs, ...}: {
  imports = [inputs.agenix.nixosModules.default];

  age = {
    identityPaths = ["/home/ryder/.ssh/id_ed25519"];
    secrets.pia.file = ../../secrets/pia.age;
  };
}

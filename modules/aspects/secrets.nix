{inputs, ...}: {
  flake-file.inputs.agenix = {
    url = "github:ryantm/agenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.secrets.nixos = {...}: {
    imports = [inputs.agenix.nixosModules.default];

    age = {
      identityPaths = ["/home/ryder/.ssh/id_ed25519"];
      secrets = {};
    };
  };

  # x86 secrets are contributed by services-x86 aspect via the same agenix module
  # The pia, steam_key, cross-seed secrets are declared where they're used (services-x86, gaming, nixarr)
}

{inputs, ...}: {
  flake-file.inputs.agenix = {
    url = "github:ryantm/agenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Just the agenix module. Identity comes from modules/user.nix; individual
  # secrets are declared by the aspect that consumes them.
  ry.secrets.nixos.imports = [inputs.agenix.nixosModules.default];
}

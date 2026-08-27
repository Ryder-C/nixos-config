{inputs, ...}: {
  flake-file.inputs.claude-desktop = {
    url = "github:poeck/claude-desktop-nix-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Anthropic's official Linux beta, repackaged from their apt repo.
  # Only x86_64-linux and aarch64-linux are published upstream.
  ry.claude-desktop.homeManager = {pkgs, ...}: {
    home.packages = [
      inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop
    ];
  };
}

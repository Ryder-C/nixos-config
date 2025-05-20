{
  pkgs,
  inputs,
  ...
}: {
  # imports = [ inputs.nix-gaming.nixosModules.default ];
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://nix-gaming.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
    };
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
    inputs.nur.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    wget
    git
    nix-search-cli
    wireguard-tools
    openrgb-with-all-plugins
    rust-bin.stable.latest.default

    inputs.agenix.packages.${system}.default
  ];

  services.udev.packages = [pkgs.via];

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
}

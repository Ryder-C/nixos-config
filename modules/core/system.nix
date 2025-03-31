{
  pkgs,
  stablePkgs,
  inputs,
  ...
}: {
  # imports = [ inputs.nix-gaming.nixosModules.default ];
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
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
    openrgb-with-all-plugins
    via
    rust-bin.stable.latest.default
    inputs.agenix.packages.${system}.default
    stablePkgs.plex-desktop
  ];

  services.udev.packages = [pkgs.via];

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
}

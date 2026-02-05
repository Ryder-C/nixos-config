{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.catppuccin.nixosModules.catppuccin];

  nix = {
    settings = {
      eval-cache = true;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://nix-gaming.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    overlays = [
      inputs.rust-overlay.overlays.default
      inputs.nur.overlays.default
      inputs.rypkgs.overlays.default
      inputs.claude-code.overlays.default
    ];

    config.permittedInsecurePackages = [
      "libsoup-2.74.3"
    ];
  };

  environment.systemPackages = with pkgs; [
    ntfs3g
    wget
    git
    gparted # partition manager
    bcachefs-tools
    inetutils
    nix-search-cli
    wireguard-tools
    openrgb-with-all-plugins
    icu

    # AppImage and FHS-like runtime for proprietary binaries/games
    appimage-run
    steam-run

    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  catppuccin = {
    enable = true;
    cache.enable = true;
    flavor = "mocha";
    accent = "mauve";

    tty.enable = false;
    limine.enable = false;
  };

  services.udev.packages = [pkgs.via];

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;
  services.logind = {
    settings = {
      Login = {
        HandlePowerKey = "poweroff";
        HandleLidSwitch = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        IdleAction = "ignore";
      };
    };
  };
  system.stateVersion = "24.05";
}

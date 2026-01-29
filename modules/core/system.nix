{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.catppuccin.nixosModules.catppuccin];

  nix = {
    settings = {
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
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
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
    # openrazer-daemon
    gparted # partition manager
    bcachefs-tools
    inetutils
    nix-search-cli
    wireguard-tools
    openrgb-with-all-plugins
    icu
    nodejs
    (rust-bin.stable.latest.default.override {
      extensions = [
        "rust-src"
        "rustfmt"
        "clippy"
      ];
      targets = ["x86_64-unknown-linux-gnu"];
    })
    rust-analyzer

    mesa-demos
    vulkan-tools

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

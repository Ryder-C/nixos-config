{
  pkgs,
  inputs,
  host,
  lib,
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
      substituters =
        [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
        ]
        ++ lib.optionals (host == "laptop") [
          "https://nixos-apple-silicon.cachix.org"
        ]
        ++ lib.optionals (host != "laptop") [
          "https://nix-gaming.cachix.org"
          "https://cuda-maintainers.cachix.org"
        ];
      trusted-public-keys =
        [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ]
        ++ lib.optionals (host == "laptop") [
          "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
        ]
        ++ lib.optionals (host != "laptop") [
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
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

  environment.systemPackages = with pkgs;
    [
      ntfs3g
      wget
      git
      gparted
      inetutils
      nix-search-cli
      wireguard-tools
      icu

      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ lib.optionals (host != "laptop") [
      bcachefs-tools
      openrgb-with-all-plugins
      appimage-run
      steam-run
    ];

  catppuccin = {
    enable = true;
    cache.enable = true;
    flavor = "mocha";
    accent = "mauve";

    tty.enable = false;
    limine.enable = false;
  };

  services.udev.packages = lib.optionals (host != "laptop") [pkgs.via];

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;
  services.logind = {
    settings = {
      Login = {
        HandlePowerKey = "poweroff";
        HandleLidSwitch = if host == "laptop" then "suspend" else "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = if host == "laptop" then "suspend" else "ignore";
        IdleAction = "ignore";
      };
    };
  };
  system.stateVersion = "24.05";

  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];
}

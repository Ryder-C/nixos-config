{inputs, ...}: {
  flake-file.inputs = {
    catppuccin.url = "github:catppuccin/nix";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    rypkgs.url = "github:Ryder-C/rypkgs";
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  ry.system.nixos = {
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.catppuccin.nixosModules.catppuccin];

    config = {
      nix = {
        package = pkgs.lixPackageSets.latest.lix;
        settings = {
          eval-cache = true;
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          substituters = [
            "https://cache.nixos.org/"
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
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
          (final: prev: {
            inherit (prev.lixPackageSets.latest)
              nixpkgs-review
              nix-eval-jobs
              nix-fast-build
              colmena;
          })
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
        gparted
        inetutils
        nix-search-cli
        wireguard-tools
        icu
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

      time.timeZone = "America/Los_Angeles";
      i18n.defaultLocale = "en_US.UTF-8";
      nixpkgs.config.allowUnfree = true;

      services.logind.settings.Login = {
        HandlePowerKey = "poweroff";
        HandleLidSwitch = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        IdleAction = "ignore";
      };

      boot.kernel.sysctl = {
        "vm.max_map_count" = 16777216;
        "fs.file-max" = 524288;
      };

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-color-emoji
      ];
    };
  };
}

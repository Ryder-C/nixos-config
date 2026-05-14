{inputs, ...}: {
  flake-file.inputs = {
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    rypkgs.url = "github:Ryder-C/rypkgs";
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  ry.system.nixos = {pkgs, ...}: {
    config = {
      nix = {
        package = pkgs.nix;
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
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
          (_final: prev: {
            # aioboto3 15.5.0 installCheck tests fail with "Duplicate 'Server' header" on newer aiohttp
            python313 = prev.python313.override {
              packageOverrides = _pyFinal: pyPrev: {
                aioboto3 = pyPrev.aioboto3.overrideAttrs (_: {doInstallCheck = false;});
                fastmcp = pyPrev.fastmcp.overrideAttrs (_: {doInstallCheck = false;});
              };
            };
            # openldap test017-syncreplication-refresh is a flaky timing-sensitive test
            openldap = prev.openldap.overrideAttrs (_: {doCheck = false;});
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

      boot.tmp.useTmpfs = false;
      boot.kernel.sysctl = {
        "vm.max_map_count" = 16777216;
        "fs.file-max" = 524288;
      };

      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        noto-fonts
        noto-fonts-color-emoji
      ];
    };
  };
}

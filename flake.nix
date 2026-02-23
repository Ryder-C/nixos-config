{
  description = "Ryder's nixos configuration";

  inputs = {
    steam-presence = {
      url = "github:JustTemmie/steam-presence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon-support = {
      url = "github:tpwrules/nixos-apple-silicon";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    rypkgs.url = "github:Ryder-C/rypkgs";
    nur.url = "github:nix-community/NUR";

    nixarr.url = "github:Ryder-C/nixarr";

    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak";

    librepods = {
      url = "github:kavishdevar/librepods/linux/rust";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dank-calculator = {
      url = "github:rochacbruno/DankCalculator";
      flake = false;
    };
    nix-monitor = {
      url = "github:antonjah/nix-monitor";
    };

    niri.url = "github:sodiboo/niri-flake";

    vesc-tool.url = "github:vedderb/vesc_tool";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";

    nix-yazi-plugins = {
      url = "github:lordkekz/nix-yazi-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-citizen = {
      url = "github:LovingMelody/nix-citizen";
      inputs.nix-gaming.follows = "nix-gaming";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-pia-vpn = {
      url = "github:rcambrj/nix-pia-vpn";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    spicetify-nix.url = "github:gerg-l/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:Ryder-C/nixvim";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-stylus-json = {
      url = "https://github.com/catppuccin/userstyles/releases/download/all-userstyles-export/import.json";
      flake = false;
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hytale-flatpak = {
      url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
      flake = false;
    };

    jj-starship = {
      url = "github:dmmulroy/jj-starship";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code.url = "github:sadjow/claude-code-nix";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    self,
    ...
  } @ inputs: let
    username = "ryder";
    x86System = "x86_64-linux";
    armSystem = "aarch64-linux";
    mkStablePkgs = system:
      import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
  in {
    checks.${x86System}.pre-commit-check = inputs.pre-commit-hooks.lib.${x86System}.run {
      src = ./.;
      hooks = {
        deadnix.enable = true;
        statix.enable = true;
        alejandra.enable = true;
      };
    };

    devShells.${x86System}.default = nixpkgs.legacyPackages.${x86System}.mkShell {
      inherit (self.checks.${x86System}.pre-commit-check) shellHook;
      buildInputs = self.checks.${x86System}.pre-commit-check.enabledPackages;
    };

    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = x86System;
        modules = [(import ./hosts/desktop)];
        specialArgs = {
          host = "desktop";
          stablePkgs = mkStablePkgs x86System;
          inherit
            self
            inputs
            username
            ;
        };
      };
      laptop = nixpkgs.lib.nixosSystem {
        modules = [
          {nixpkgs.hostPlatform = armSystem;}
          (import ./hosts/laptop)
        ];
        specialArgs = {
          host = "laptop";
          stablePkgs = mkStablePkgs armSystem;
          inherit
            self
            inputs
            username
            ;
        };
      };
      vm = nixpkgs.lib.nixosSystem {
        system = x86System;
        modules = [(import ./hosts/vm)];
        specialArgs = {
          host = "vm";
          stablePkgs = mkStablePkgs x86System;
          inherit
            self
            inputs
            username
            ;
        };
      };
    };
  };
}

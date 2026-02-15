{
  description = "Ryder's nixos configuration";

  inputs = {
    steam-presence = {
      url = "github:JustTemmie/steam-presence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    system = "x86_64-linux";
    stablePkgs = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    checks.${system}.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
      src = ./.;
      hooks = {
        deadnix.enable = true;
        statix.enable = true;
        alejandra.enable = true;
      };
    };

    devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
      inherit (self.checks.${system}.pre-commit-check) shellHook;
      buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
    };

    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [(import ./hosts/desktop)];
        specialArgs = {
          host = "desktop";
          inherit
            self
            inputs
            username
            stablePkgs
            ;
        };
      };
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [(import ./hosts/laptop)];
        specialArgs = {
          host = "laptop";
          inherit
            self
            inputs
            username
            stablePkgs
            ;
        };
      };
      vm = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [(import ./hosts/vm)];
        specialArgs = {
          host = "vm";
          inherit
            self
            inputs
            username
            stablePkgs
            ;
        };
      };
    };
  };
}

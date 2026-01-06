{
  description = "Ryder's nixos configuration";

  inputs = {
    # ryderpkgs = {
    #   url = "github:Ryder-C/ryderpkgs";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    steam-presence = {
      url = "github:JustTemmie/steam-presence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nur.url = "github:nix-community/NUR";

    # nixarr.url = "github:rasmus-kirk/nixarr";
    nixarr.url = "github:Ryder-C/nixarr"; # use my fork with multi instance

    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mechabar = {
      url = "github:sejjy/mechabar";
      flake = false;
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-monitor = {
      url = "github:antonjah/nix-monitor";
    };

    niri.url = "github:sodiboo/niri-flake";

    vesc-tool.url = "github:vedderb/vesc_tool";

    nixcord = {
      url = "github:kaylorben/nixcord";
    };

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

    nixvim.url = "github:Ryder-C/nixvim";

    wezterm.url = "github:wez/wezterm?dir=nix";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-stylus-json = {
      url = "https://github.com/catppuccin/userstyles/releases/download/all-userstyles-export/import.json";
      flake = false;
    };

    fuzzel-scripts = {
      url = "github:thnikk/fuzzel-scripts";
      flake = false;
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
    nixosConfigurations = {
      nixos = self.nixosConfigurations.desktop;
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

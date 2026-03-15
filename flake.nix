# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    aagl = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ezKEa/aagl-gtk-on-nix";
    };
    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };
    alejandra.url = "github:kamadorueda/alejandra";
    apple-silicon-support.url = "github:tpwrules/nixos-apple-silicon";
    catppuccin.url = "github:catppuccin/nix";
    catppuccin-stylus-json = {
      flake = false;
      url = "https://github.com/catppuccin/userstyles/releases/download/all-userstyles-export/import.json";
    };
    claude-code.url = "github:sadjow/claude-code-nix";
    dank-calculator = {
      flake = false;
      url = "github:rochacbruno/DankCalculator";
    };
    den.url = "github:vic/den";
    discord-catppuccin = {
      flake = false;
      url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    };
    dms = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:AvengeMedia/DankMaterialShell/stable";
    };
    flake-aspects.url = "github:vic/flake-aspects";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    hytale-flatpak = {
      flake = false;
      url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
    };
    import-tree.url = "github:vic/import-tree";
    jj-starship = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:dmmulroy/jj-starship";
    };
    librepods = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:kavishdevar/librepods/linux/rust";
    };
    niri.url = "github:sodiboo/niri-flake";
    nix-citizen = {
      inputs.nix-gaming.follows = "nix-gaming";
      url = "github:LovingMelody/nix-citizen";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };
    nix-monitor.url = "github:antonjah/nix-monitor";
    nix-pia-vpn = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rcambrj/nix-pia-vpn";
    };
    nix-yazi-plugins = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lordkekz/nix-yazi-plugins";
    };
    nixarr = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Ryder-C/nixarr/multi-instance-support";
    };
    nixcord = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:kaylorben/nixcord";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixvim.url = "github:Ryder-C/nixvim";
    nur.url = "github:nix-community/NUR";
    rust-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:oxalica/rust-overlay";
    };
    rycharger = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Ryder-C/rycharger";
    };
    rypkgs.url = "github:Ryder-C/rypkgs";
    spicetify-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:gerg-l/spicetify-nix";
    };
    steam-presence = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:JustTemmie/steam-presence";
    };
    vesc-tool.url = "github:vedderb/vesc_tool";
  };

}

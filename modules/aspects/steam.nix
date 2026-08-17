{inputs, ...}: {
  flake-file.inputs = {
    steam-presence = {
      url = "github:JustTemmie/steam-presence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    proton-cachyos-nix = {
      url = "github:powerofthe69/proton-cachyos-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Steam, gamescope, gamemode
  ry.steam = {
    nixos = {pkgs, ...}: {
      imports = [inputs.steam-presence.nixosModules.steam-presence];

      programs = {
        steam = {
          enable = true;
          protontricks.enable = true;
          extraCompatPackages = [
            pkgs.proton-ge-bin
            inputs.proton-cachyos-nix.packages.${pkgs.stdenv.hostPlatform.system}.proton-cachyos-x86_64-v3
          ];
        };
        gamescope = {
          enable = true;
          capSysNice = false;
        };
        gamemode = {
          enable = true;
          enableRenice = true;
        };
      };
    };

    homeManager = {
      pkgs,
      stablePkgs,
      ...
    }: {
      home.packages = with pkgs; [
        winetricks
        mangohud
        waywall
        glfw3-minecraft
        inputs.proton-cachyos-nix.packages.${pkgs.stdenv.hostPlatform.system}.proton-cachyos-x86_64-v3
        stablePkgs.lutris
      ];

      # Expose proton-cachyos to Heroic (it scans this dir; Steam reads
      # extraCompatPackages via env var instead, so it doesn't end up here).
      # The default output only ships `share/`; the `steamcompattool` output
      # is the one with `proton`, `compatibilitytool.vdf`, etc.
      home.file.".steam/root/compatibilitytools.d/proton-cachyos".source =
        inputs.proton-cachyos-nix.packages.${pkgs.stdenv.hostPlatform.system}.proton-cachyos-x86_64-v3.steamcompattool;
    };
  };
}

{inputs, ...}: {
  flake-file.inputs = {
    steam-presence = {
      url = "github:JustTemmie/steam-presence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hytale-flatpak = {
      url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
      flake = false;
    };
  };

  # Gaming HM packages (all hosts)
  ry.gaming.homeManager = {pkgs, ...}: let
    stablePkgs = import inputs.nixpkgs-stable {
      inherit (pkgs.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  in {
    home.packages = with pkgs; [
      ## Minecraft
      stablePkgs.prismlauncher
      libxkbcommon

      ## Cli games
      vitetris
      nethack
    ];
  };

  # Steam, gamescope, gamemode (x86 only — reached via x86-workstation includes)
  ry.gaming-x86 = {
    nixos = {pkgs, config, ...}: {
      imports = [inputs.steam-presence.nixosModules.steam-presence];

      environment.sessionVariables = {
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
        __GL_VRR_ALLOWED = "0";
      };

      programs = {
        steam = {
          enable = true;
          protontricks.enable = true;
          extraCompatPackages = [
            pkgs.proton-ge-bin
          ];
          presence = {
            enable = true;
            steamApiKeyFile = config.age.secrets.steam_key.path;
            userIds = ["76561198311078521"];
          };
        };
        gamescope = {
          enable = true;
          capSysNice = true;
        };
        gamemode = {
          enable = true;
          enableRenice = true;
        };
      };

      services.ananicy = {
        enable = true;
        extraRules = [
          {
            "name" = "gamescope";
            "nice" = -20;
          }
        ];
      };

      age.secrets.steam_key = {
        file = ../../secrets/steam_key.age;
        owner = "ryder";
        mode = "0400";
      };
    };

    homeManager = {pkgs, ...}: let
      stablePkgs = import inputs.nixpkgs-stable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    in {
      home.packages = with pkgs; [
        winetricks
        mangohud
        waywall
        glfw3-minecraft
        stablePkgs.lutris
      ];
    };
  };
}

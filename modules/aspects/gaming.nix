{inputs, ry, ...}: {
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
  ry.gaming.homeManager = {
    pkgs,
    stablePkgs,
    ...
  }: {
    home.packages = with pkgs; [
      osu-lazer

      ## Minecraft
      stablePkgs.prismlauncher
      libxkbcommon

      ## Cli games
      vitetris
      nethack
    ];
  };

  # Steam, gamescope, gamemode
  ry.steam = {
    nixos = {
      pkgs,
      config,
      ...
    }: {
      imports = [inputs.steam-presence.nixosModules.steam-presence];

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
          capSysNice = false;
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
        stablePkgs.lutris
      ];
    };
  };

  # Headless gamescope session (e.g. streaming server)
  ry.gamescope-kiosk = {
    includes = [ry.steam];
    nixos = {
      programs.steam.gamescopeSession = {
        enable = true;
        args = [
          "-W 3840"
          "-H 2160"
          "-w 3840"
          "-h 2160"
          "-r 60"
          "-o 60"
          "--force-grab-cursor"
        ];
      };
    };
  };
}

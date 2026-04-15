{inputs, ...}: {
  flake-file.inputs.nix-minecraft.url = "github:Infinidoge/nix-minecraft";

  ry.minecraft.nixos = {
    pkgs,
    lib,
    ...
  }: let
    create-plus = pkgs.fetchModrinthModpack {
      url = "https://cdn.modrinth.com/data/HqonU57y/versions/eWxy1cNe/Create%2B%204.0.0-b.mrpack";
      packHash = lib.fakeHash;
      side = "server";
    };
  in {
    imports = [
      inputs.nix-minecraft.nixosModules.minecraft-servers
    ];

    ry.caddy.vhosts."mc" = 25565;

    nixpkgs.overlays = [inputs.nix-minecraft.overlay];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers.genius = {
        enable = true;
        autoStart = true;
        package = pkgs.fabricServers.fabric-1_20_1;

        serverProperties = {
          white-list = true;
          difficulty = 3;
          gamemode = 0;
          motd = "i guess";
        };

        symlinks = {
          "mods" = "${create-plus}/mods";
        };
        files = {
          "config" = "${create-plus}/config";
        };
      };
    };
  };
}

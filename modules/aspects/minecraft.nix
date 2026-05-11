{inputs, ...}: {
  flake-file.inputs.nix-minecraft.url = "github:Infinidoge/nix-minecraft";

  ry.minecraft.nixos = {
    pkgs,
    config,
    ...
  }: let
    voiceChat = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/ZQfVgh62/voicechat-bukkit-2.6.16.jar";
      sha256 = "0c7z56qkd2avn49135jhk42b5dxn0rixsjcs5bzrnaqkylaw3dyj";
    };

    blueMap = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/swbUV1cr/versions/jPyegm5Q/bluemap-5.20-paper.jar";
      sha256 = "0fb3h3g9wx36mnmzcw944mzs74lyjyka3b5p0jd0i9wafa5wjff9";
    };

    distantHorizons = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/IjY7seTG/versions/O7tD7FNe/DistantHorizonsSupport-0.13.0.jar";
      sha256 = "1vz40sck9an2xikfsb9lalls3ayv1h8qbw26qn6v5c1zxjpcz6sw";
    };
  in {
    imports = [
      inputs.nix-minecraft.nixosModules.minecraft-servers
    ];

    nixpkgs.overlays = [inputs.nix-minecraft.overlay];

    networking.firewall = {
      allowedUDPPorts = [8100 24454];
    };

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      managementSystem.systemd-socket.enable = true;

      servers.genius-vanilla = {
        enable = true;
        autoStart = true;

        package = pkgs.purpur-server.override {jre = pkgs.jdk25;};

        serverProperties = {
          white-list = true;
          enforce-secure-profile = false;
          spawn-protection = 0;
          difficulty = 3;
          gamemode = 0;
          motd = "i guess";

          view-distance = 16;
          simulation-distance = 10;
        };

        files = {
          "plugins/voicechat-bukkit-2.6.16.jar" = voiceChat;
          "plugins/bluemap-5.20-paper.jar" = blueMap;
          "plugins/DistantHorizonsSupport-0.13.0.jar" = distantHorizons;
        };

        jvmOpts = "-Xmx12G -Xms12G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";
      };
    };

    ry.homepage.services."Game" = [
      {
        "Minecraft" = {
          href = "http://${config.networking.hostName}:8100";
          icon = "minecraft";
          widget = {
            type = "minecraft";
            url = "udp://localhost:25565";
          };
        };
      }
    ];
  };
}

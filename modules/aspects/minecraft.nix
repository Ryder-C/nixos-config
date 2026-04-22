{inputs, ...}: {
  flake-file.inputs.nix-minecraft.url = "github:Infinidoge/nix-minecraft";

  ry.minecraft.nixos = {pkgs, ...}: let
    prominence = pkgs.fetchModrinthModpack {
      url = "https://cdn.modrinth.com/data/EGs3lC8D/versions/GoepRBzX/Prominence%20II%20Hasturian%20Era%203.9.26.mrpack";
      packHash = "sha256-WLx+mrGz6oClwp8wvP4uEHjI8S5PIspbPShV0sIpk2Y=";
      side = "server";
    };

    ftbLibrary = pkgs.fetchurl {
      url = "https://mediafilez.forgecdn.net/files/6164/52/ftb-library-fabric-2001.2.9.jar";
      sha256 = "1kjj2v6db2wjcv9gba1pmxdin0w7wjlgbqgcidhccwrzmq3h3s08";
    };
    ftbQuests = pkgs.fetchurl {
      url = "https://mediafilez.forgecdn.net/files/6431/736/ftb-quests-fabric-2001.4.13.jar";
      sha256 = "1xj37f13qshmpj87mddn7vlxgf82mz9dz0a9qprd05g8hsqm22kj";
    };
    ftbTeams = pkgs.fetchurl {
      url = "https://mediafilez.forgecdn.net/files/6130/783/ftb-teams-fabric-2001.3.1.jar";
      sha256 = "1j5ixd1m5ln2hrnkmgyl3kk0cc7v8im7p0x7jv8m712m19417lip";
    };
    ftbXmodCompat = pkgs.fetchurl {
      url = "https://mediafilez.forgecdn.net/files/6402/485/ftb-xmod-compat-fabric-2.1.3.jar";
      sha256 = "1vn9vmqcdwxc9bc62nkdmw6r0l6csvm1al7i5kka33fkzz3gzivk";
    };

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

    fabricKotlin = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/LcgnDDmT/fabric-language-kotlin-1.13.7%2Bkotlin.2.2.21.jar";
      hash = "sha1-q3Ho2vmi1SkgS1wos4AXE9IvPUY=";
    };

    mods = pkgs.runCommand "prominence-with-ftb" {} ''
      mkdir -p $out
      for f in ${prominence}/mods/*; do
        fname=$(basename "$f")
        case "$fname" in
          fabric-language-kotlin*) ;;
          *) ln -s "$f" "$out/$fname" ;;
        esac
      done
      ln -s ${fabricKotlin} "$out/fabric-language-kotlin-1.13.7+kotlin.2.2.21.jar"
      ln -s ${ftbLibrary} "$out/ftb-library-fabric-2001.2.9.jar"
      ln -s ${ftbQuests} "$out/ftb-quests-fabric-2001.4.13.jar"
      ln -s ${ftbTeams} "$out/ftb-teams-fabric-2001.3.1.jar"
      ln -s ${ftbXmodCompat} "$out/ftb-xmod-compat-fabric-2.1.3.jar"
    '';
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

      servers.genius = {
        enable = false;
        autoStart = true;
        # package = pkgs.neoforgeServers.neoforge-1_21_1;
        # package = pkgs.purpur-server.override {jre = pkgs.jdk25;};
        package = pkgs.fabricServers.fabric-1_20_1;

        serverProperties = {
          white-list = true;
          difficulty = 3;
          gamemode = 0;
          motd = "i guess";
        };

        jvmOpts = "-Xmx8G -Xms4G";

        files = {
          "mods" = mods;
          "config" = "${prominence}/config";
        };
      };
      servers.genius-vanilla = {
        enable = true;
        autoStart = true;

        package = pkgs.purpur-server.override {jre = pkgs.jdk25;};

        serverProperties = {
          white-list = true;
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
  };
}

{inputs, ...}: {
  flake-file.inputs.flatpaks.url = "github:in-a-dil-emma/declarative-flatpak";

  ry.flatpak = {
    nixos.services.flatpak.enable = true;

    homeManager = {
      pkgs,
      config,
      ...
    }: let
      hytale-flatpak = pkgs.runCommand "hytale-launcher.flatpak" {} ''
        ln -s ${inputs.hytale-flatpak} $out
      '';
    in {
      imports = [inputs.flatpaks.homeModules.default];

      home.packages = [pkgs.flatpak];

      services.flatpak = {
        enable = true;
        remotes = {
          "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        };
        packages = [
          "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
          "flathub:app/com.heroicgameslauncher.hgl/x86_64/stable"
          "flathub:app/org.vinegarhq.Sober/x86_64/stable"
          "flathub:app/tv.plex.PlexDesktop/x86_64/stable"
          "flathub:app/org.jellyfin.JellyfinDesktop/x86_64/stable"
          ":${hytale-flatpak}"

          "flathub:runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/25.08"
          "flathub:runtime/org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/25.08"
        ];
        overrides = {
          "com.heroicgameslauncher.hgl".Context = {
            filesystems = ["host"];
          };
          "io.github.mactan_sc.RSILauncher" = {
            Context = {
              filesystems = ["~/Games/rsi-launcher"];
            };
            Environment = {
              WINEPREFIX = "${config.home.homeDirectory}/Games/rsi-launcher";
            };
          };
          "tv.plex.PlexDesktop".Environment = {
            QT_QPA_PLATFORM = "xcb";
          };
        };
      };
    };
  };
}

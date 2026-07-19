{inputs, ...}: {
  flake-file.inputs = {
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak";
    hytale-flatpak = {
      url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
      flake = false;
    };
    jellium-flatpak = {
      url = "https://nightly.link/andrewrabert/jellium-desktop/workflows/build-linux-flatpak/main/linux-flatpak-x86_64.zip";
      flake = false;
    };
  };

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
      jellium-flatpak = pkgs.runCommand "jellium-desktop.flatpak" {} ''
        ln -s "$(echo ${inputs.jellium-flatpak}/*.flatpak)" $out
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
          "flathub:app/org.vinegarhq.Sober/x86_64/stable"
          "flathub:app/tv.plex.PlexDesktop/x86_64/stable"
          ":${hytale-flatpak}"
          ":${jellium-flatpak}"
        ];
        overrides = {
          "tv.plex.PlexDesktop".Environment = {
            QT_QPA_PLATFORM = "xcb";
          };
        };
      };
    };
  };
}

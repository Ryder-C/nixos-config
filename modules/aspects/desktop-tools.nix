{inputs, ...}: {
  ry.desktop-tools = {
    nixos = {pkgs, ...}: {
      nix.settings = {
        substituters = [
          "https://nix-gaming.cachix.org"
          "https://cuda-maintainers.cachix.org"
        ];
        trusted-public-keys = [
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
      };

      environment.systemPackages = with pkgs; [
        bcachefs-tools
        openrgb-with-all-plugins
        appimage-run
        steam-run
      ];

      services.udev.packages = [pkgs.via];
    };

    homeManager = {
      pkgs,
      config,
      ...
    }: {
      home.packages = with pkgs; [
        unityhub
        valgrind
        gpu-screen-recorder-gtk
        wineWow64Packages.waylandFull
        (bottles.override {removeWarningPopup = true;})
        inputs.vesc-tool.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.rypkgs.packages.${pkgs.stdenv.hostPlatform.system}.blink
        tor-browser
        zoom-us
      ];

      xdg.dataFile."icons/hicolor/scalable/apps/org.vinegarhq.Sober.svg" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/flatpak/exports/share/icons/hicolor/scalable/apps/org.vinegarhq.Sober.svg";
      };
    };
  };
}

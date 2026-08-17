{inputs, ...}: {
  ry.desktop-tools = {
    nixos = {pkgs, ...}: {
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
      stablePkgs,
      config,
      ...
    }: {
      home.packages = with pkgs; [
        unityhub
        valgrind
        gpu-screen-recorder-gtk
        wineWow64Packages.waylandFull
        (stablePkgs.bottles.override {removeWarningPopup = true;})
        inputs.vesc-tool.packages.${pkgs.stdenv.hostPlatform.system}.default
        tor-browser
        zoom-us
      ];

      xdg.dataFile."icons/hicolor/scalable/apps/org.vinegarhq.Sober.svg" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/flatpak/exports/share/icons/hicolor/scalable/apps/org.vinegarhq.Sober.svg";
      };
    };
  };
}

_: {
  flake-file.inputs.vesc-tool.url = "github:vedderb/vesc_tool";

  ry.packages.homeManager = {
    pkgs,
    lib,
    stablePkgs,
    ...
  }: let
    toggle-hdr = pkgs.callPackage ../../pkgs/hdr-toggle/default.nix {};

    zink-env = [
      "__GLX_VENDOR_LIBRARY_NAME=mesa"
      "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json"
      "MESA_LOADER_DRIVER_OVERRIDE=zink"
      "GALLIUM_DRIVER=zink"
      "WEBKIT_DISABLE_DMABUF_RENDERER=1"
    ];
  in {
    home.packages = with pkgs; [
      asciiquarium-transparent
      audacity
      bandwhich
      baobab
      brightnessctl
      bitwise
      cbonsai
      dua
      entr
      eza
      fd
      file
      fzf
      gifsicle
      gtrash
      gtt
      hexdump
      jdk17
      jq
      lazygit
      libreoffice
      lorien
      monero-gui
      nil
      nitch
      nix-prefetch-github
      obsidian
      pipes
      ripgrep
      tdf
      todo
      toipe
      toggle-hdr
      unrar
      websocat
      xwayland-run

      zenity

      kdePackages.kleopatra

      # C / C++
      gcc
      gnumake

      # Python
      python3
      python312Packages.setuptools
      python312Packages.virtualenv
      python312Packages.gmpy2

      bleachbit
      cmatrix
      spotify-player
      ffmpeg
      imv
      killall
      libnotify
      man-pages
      gdu
      openssl
      stablePkgs.pamixer
      pavucontrol
      playerctl
      wl-clipboard
      cliphist
      poweralertd
      qalculate-gtk
      unzip
      xdg-utils
      xxd

      tinymist

      # 3D printing
      orca-slicer

      libvlc
      zathura
      leetgo
    ];

    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = ["thunar.desktop"];
        };
      };

      dataFile = {
        "applications/mimeapps.list".force = true;
      };

      desktopEntries."OrcaSlicer" = {
        name = "OrcaSlicer";
        exec = "env ${lib.concatStringsSep " " zink-env} orca-slicer %U";
        icon = "OrcaSlicer";
        categories = [
          "Graphics"
          "3DGraphics"
          "Engineering"
        ];
        mimeType = [
          "model/stl"
          "model/3mf"
          "application/vnd.ms-3mfdocument"
          "application/prs.wavefront-obj"
          "application/x-amf"
          "x-scheme-handler/orcaslicer"
        ];
        terminal = false;
        type = "Application";
        settings = {
          StartupWMClass = "orca-slicer";
        };
      };
    };
  };
}

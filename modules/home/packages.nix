{
  inputs,
  lib,
  pkgs,
  stablePkgs,
  config,
  host,
  ...
}: let
  isDesktop = host != "laptop";

  toggle-hdr = pkgs.callPackage ../../pkgs/hdr-toggle/default.nix {};

  zink-env = [
    "__GLX_VENDOR_LIBRARY_NAME=mesa"
    "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json"
    "MESA_LOADER_DRIVER_OVERRIDE=zink"
    "GALLIUM_DRIVER=zink"
    "WEBKIT_DISABLE_DMABUF_RENDERER=1"
  ];

  hytale-flatpak = pkgs.runCommand "hytale-launcher.flatpak" {} ''
    ln -s ${inputs.hytale-flatpak} $out
  '';
in {
  imports = [inputs.flatpaks.homeModules.default];

  home.packages = with pkgs;
    [
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
      flatpak
      gifsicle
      gtrash
      gtt
      hexdump
      jellyfin-media-player
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
      mpv
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
    ]
    ++ lib.optionals isDesktop [
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

  services = {
    flatpak = lib.mkMerge [
      {
        enable = true;
        remotes = {
          "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        };
      }
      (lib.mkIf isDesktop {
        packages = [
          "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
          "flathub:app/com.heroicgameslauncher.hgl/x86_64/stable"
          "flathub:app/org.vinegarhq.Sober/x86_64/stable"
          "flathub:app/tv.plex.PlexDesktop/x86_64/stable"
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
      })
    ];
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["thunar.desktop"];
      };
    };

    dataFile = lib.mkMerge [
      {
        "applications/mimeapps.list".force = true;
      }
      (lib.mkIf isDesktop {
        "icons/hicolor/scalable/apps/org.vinegarhq.Sober.svg" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/flatpak/exports/share/icons/hicolor/scalable/apps/org.vinegarhq.Sober.svg";
        };
      })
    ];

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
}

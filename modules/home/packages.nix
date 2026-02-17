{
  inputs,
  lib,
  pkgs,
  stablePkgs,
  config,
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

  hytale-flatpak = pkgs.runCommand "hytale-launcher.flatpak" {} ''
    ln -s ${inputs.hytale-flatpak} $out
  '';
in {
  imports = [inputs.flatpaks.homeModules.default];

  home.packages = with pkgs; [
    asciiquarium-transparent
    audacity
    bandwhich
    baobab # GNOME Disk Usage Analyzer
    brightnessctl
    bitwise # cli tool for bit / hex manipulation
    cbonsai # terminal screensaver
    dua # graphical disk analyzer
    entr # perform action when file change
    eza # ls replacement
    fd # find replacement
    file # Show file information
    fzf # fuzzy finder
    flatpak
    gifsicle # gif utility
    gtrash # rm replacement, put deleted files in system trash
    gtt # google translate TUI
    hexdump
    jellyfin-media-player
    jdk17 # java
    jq
    lazygit
    libreoffice
    lorien
    monero-gui
    nil
    nitch # systhem fetch util
    nix-prefetch-github
    obsidian
    pipes # terminal screensaver
    ripgrep # grep replacement
    soundwireserver # pass audio to android phone
    tdf # cli pdf viewer
    todo # cli todo list
    toipe # typing test in the terminal
    tor-browser
    toggle-hdr
    unrar
    unityhub
    valgrind # c memory analyzer
    websocat
    xwayland-run
    yt-dlp-light
    zenity

    kdePackages.kleopatra
    wineWow64Packages.waylandFull

    # C / C++
    gcc
    gnumake

    # Python
    python3
    python312Packages.setuptools
    python312Packages.virtualenv
    python312Packages.gmpy2

    bleachbit # cache cleaner
    cmatrix
    spotify-player
    ffmpeg
    gpu-screen-recorder-gtk
    imv # image viewer
    killall
    libnotify
    man-pages # extra man pages
    mpv # video player
    gdu # disk space
    openssl
    stablePkgs.pamixer # pulseaudio command line mixer
    pavucontrol # pulseaudio volume controle (GUI)
    playerctl # controller for media players
    wl-clipboard # clipboard utils for wayland (wl-copy, wl-paste)
    cliphist # clipboard manager
    poweralertd
    qalculate-gtk # calculator
    unzip
    xdg-utils
    xxd
    inputs.vesc-tool.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.rypkgs.packages.${pkgs.stdenv.hostPlatform.system}.blink

    tinymist

    zoom-us

    (bottles.override {removeWarningPopup = true;})

    # 3D printing
    orca-slicer

    libvlc
    zathura # PDF Viewer
    leetgo
  ];

  services = {
    flatpak = {
      enable = true;
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
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
    };
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["thunar.desktop"];
      };
    };

    dataFile = {
      "applications/mimeapps.list".force = true;
      "icons/hicolor/scalable/apps/org.vinegarhq.Sober.svg" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/flatpak/exports/share/icons/hicolor/scalable/apps/org.vinegarhq.Sober.svg";
      };
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
}

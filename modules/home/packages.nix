{
  inputs,
  lib,
  pkgs,
  stablePkgs,
  config,
  ...
}: let
  _2048 = pkgs.callPackage ../../pkgs/2048/default.nix {};

  zink-env = [
    "__GLX_VENDOR_LIBRARY_NAME=mesa"
    "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json"
    "MESA_LOADER_DRIVER_OVERRIDE=zink"
    "GALLIUM_DRIVER=zink"
    "WEBKIT_DISABLE_DMABUF_RENDERER=1"
  ];
in {
  imports = [inputs.flatpaks.homeModules.default];

  home.packages = with pkgs; [
    _2048

    asciiquarium-transparent
    audacity
    bandwhich
    baobab # GNOME Disk Usage Analyzer
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
    jellyfin
    jdk17 # java
    jq
    lazygit
    libreoffice
    lorien
    monero-gui
    nautilus # file manager
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
    unrar
    valgrind # c memory analyzer
    websocat
    yt-dlp-light
    zenity

    kdePackages.kleopatra
    # winetricks
    wineWowPackages.waylandFull
    # wine
    # (wine.override { wineBuild = "wine64"; })
    # wine64

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
    ncspot
    ffmpeg
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
    wget
    xdg-utils
    xxd
    inputs.alejandra.defaultPackage.${pkgs.system}

    zed-editor # code editor
    codex
    tinymist

    google-chrome
    zoom-us

    (bottles.override {removeWarningPopup = true;})
    vscode
    # kicad
    (stablePkgs.blender.override {cudaSupport = true;})
    obs-studio

    # 3D printing
    orca-slicer
    # (pkgs.writeShellScriptBin "orca-slicer-wayland" ''
    #   ${builtins.concatStringsSep "\n" (map (e: "export ${e}") zink-env)}
    #   exec ${pkgs.orca-slicer}/bin/orca-slicer "$@"
    # '')

    typst
    typstyle

    libvlc
    zathura # PDF Viewer
    leetgo
    sunshine
  ];

  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
    packages = [
      "flathub:app/org.vinegarhq.Sober/x86_64/stable"
      "flathub:app/tv.plex.PlexDesktop/x86_64/stable"
    ];
    overrides."tv.plex.PlexDesktop".environment = {
      QT_STYLE_OVERRIDE = "Fusion";
      QT_QUICK_CONTROLS_STYLE = "Fusion";
    };
  };

  xdg = {
    dataFile = {
      "applications/flatpak" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/flatpak/exports/share/applications";
      };
      "icons/hicolor/scalable/apps/org.vinegarhq.Sober.svg" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/flatpak/exports/share/icons/hicolor/scalable/apps/org.vinegarhq.Sober.svg";
      };
    };

    desktopEntries."OrcaSlicer" = {
      name = "OrcaSlicer";
      exec = "env ${lib.concatStringsSep " " zink-env} orca-slicer %U";
      icon = "OrcaSlicer";
      categories = ["Graphics" "3DGraphics" "Engineering"];
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

{
  inputs,
  pkgs,
  lib,
  stablePkgs,
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
  home.packages = with pkgs; [
    _2048

    audacity
    asciiquarium-transparent
    baobab # GNOME Disk Usage Analyzer
    bitwise # cli tool for bit / hex manipulation
    cbonsai # terminal screensaver
    eza # ls replacement
    entr # perform action when file change
    fd # find replacement
    file # Show file information
    fzf # fuzzy finder
    # sesh # terminal session manager
    gtt # google translate TUI
    gifsicle # gif utility
    # gimp
    gtrash # rm replacement, put deleted files in system trash
    websocat
    hexdump
    jdk17 # java
    lazygit
    libreoffice
    nautilus # file manager
    nitch # systhem fetch util
    nix-prefetch-github
    pipes # terminal screensaver
    ripgrep # grep replacement
    soundwireserver # pass audio to android phone
    tdf # cli pdf viewer
    todo # cli todo list
    toipe # typing test in the terminal
    bandwhich
    unrar
    valgrind # c memory analyzer
    dua # graphical disk analyzer
    yt-dlp-light
    zenity
    tor-browser
    monero-gui
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
    ncdu # disk space
    openssl
    pamixer # pulseaudio command line mixer
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
    inputs.alejandra.defaultPackage.${system}

    zed-editor # code editor
    codex
    tinymist

    google-chrome
    zoom-us

    bottles
    vscode
    code-cursor
    # kicad
    (stablePkgs.blender.override {cudaSupport = true;})
    obs-studio

    # 3D printing
    # orca-slicer
    (pkgs.writeShellScriptBin "orca-slicer-wayland" ''
      ${builtins.concatStringsSep "\n" (map (e: "export ${e}") zink-env)}
      exec ${pkgs.orca-slicer}/bin/orca-slicer "$@"
    '')

    typst
    typstyle

    libvlc
    zathura # PDF Viewer
    leetgo
    gdu # disk usage
    # stablePkgs.plex-desktop
    sunshine
    plex-desktop
  ];

  # xdg.desktopEntries."orca-slicer" = {
  #   name = "OrcaSlicer";
  #   exec = "env ${lib.concatStringsSep " " zink-env} orca-slicer %F";
  #   icon = "orca-slicer";
  #   categories = ["Utility"];
  # };
}

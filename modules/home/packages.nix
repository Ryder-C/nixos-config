{
  inputs,
  pkgs,
  ...
}: let
  _2048 = pkgs.callPackage ../../pkgs/2048/default.nix {};
in {
  home.packages = with pkgs; [
    _2048

    audacity
    asciiquarium-transparent
    bitwise # cli tool for bit / hex manipulation
    cbonsai # terminal screensaver
    evince # gnome pdf viewer
    eza # ls replacement
    entr # perform action when file change
    fd # find replacement
    file # Show file information
    fzf # fuzzy finder
    gtt # google translate TUI
    gifsicle # gif utility
    gimp
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
    prismlauncher # minecraft launcher
    ripgrep # grep replacement
    soundwireserver # pass audio to android phone
    tdf # cli pdf viewer
    todo # cli todo list
    toipe # typing test in the terminal
    bandwhich
    valgrind # c memory analyzer
    yazi # terminal file manager
    yt-dlp-light
    zenity
    tor-browser
    monero-gui
    kdePackages.kleopatra
    # winetricks
    # wineWowPackages.waylandFull
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
    gparted # partition manager
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
    inputs.nixvim.packages.${system}.default

    zed-editor # code editor
    tinymist

    pkg-config-unwrapped
    google-chrome

    bottles
    # kicad
    blender
    obs-studio
    transmission_4-qt

    # 3D printing
    orca-slicer

    typst

    plex-desktop
    libvlc
    zathura # PDF Viewer
    leetgo
    gdu # disk usage
  ];
}

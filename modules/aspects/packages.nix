_: {
  flake-file.inputs.vesc-tool.url = "github:vedderb/vesc_tool";

  ry.packages.homeManager = {
    pkgs,
    lib,
    stablePkgs,
    isLinux,
    ...
  }: {
    home.packages = with pkgs;
      [
        bandwhich
        bitwarden-cli
        bitwise
        cbonsai
        dua
        entr
        eza
        fd
        file
        fladder
        fzf
        jdk25
        jq
        lazygit
        nix-prefetch-github
        obsidian
        pipes
        ripgrep
        tdf
        todo
        toipe
        unrar
        websocat
        wl-mirror

        # C / C++
        gcc
        gnumake

        # Python
        python3
        python312Packages.setuptools
        python312Packages.virtualenv
        python312Packages.gmpy2

        cmatrix
        spotify-player
        ffmpeg
        killall
        man-pages
        gdu
        openssl
        unzip
        xxd

        tinymist
        leetgo
      ]
      ++ lib.optionals isLinux [
        nitch
        asciiquarium-transparent
        audacity
        baobab
        brightnessctl
        gifsicle
        gtrash
        gtt
        hexdump
        lorien
        monero-gui
        xwayland-run
        zenity
        kdePackages.kleopatra
        bleachbit
        imv
        libnotify
        stablePkgs.pamixer
        pavucontrol
        playerctl
        wl-clipboard
        cliphist
        poweralertd
        qalculate-gtk
        xdg-utils
        libvlc
        zathura

        # 3D printing
        orca-slicer
      ];
  };
}

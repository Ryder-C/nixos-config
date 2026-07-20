_: {
  flake-file.inputs.vesc-tool.url = "github:vedderb/vesc_tool";

  ry.packages.homeManager = {
    pkgs,
    lib,
    stablePkgs,
    isLinux,
    ...
  }: let
    zink-env = [
      "__GLX_VENDOR_LIBRARY_NAME=mesa"
      "__EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json"
      "MESA_LOADER_DRIVER_OVERRIDE=zink"
      "GALLIUM_DRIVER=zink"
      "WEBKIT_DISABLE_DMABUF_RENDERER=1"
    ];
  in {
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
        fzf
        jdk25
        jq
        lazygit
        nix-prefetch-github
        obsidian
        pipes
        plezy
        ripgrep
        tdf
        todo
        toipe
        unrar
        websocat

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

    xdg = lib.mkIf isLinux {
      mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = ["thunar.desktop"];
        };
      };

      dataFile = {
        "applications/mimeapps.list".force = true;
      };
    };
  };
}

{pkgs, ...}: {
  programs = {
    thunar.enable = true;
    dconf.enable = true;
    fish.enable = true;
    firejail.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      gtk3
      glib
      gdk-pixbuf
      pango
      harfbuzz
      atk
      cairo
      libepoxy
      mpv
      keybinder3
      gsettings-desktop-schemas
      zlib
      alsa-lib
      fontconfig
      freetype
      libxkbcommon
      libdrm
      libxcb
      wayland
      libx11
      libxext
      libxrender
      libxfixes
      libxinerama
      libxi
      libxrandr
      libxscrnsaver
      libxtst
      libxcb-util
      libxcb-image
      libxcb-render-util
      libxcb-wm
      libxcb-keysyms
      libva
    ];

    # nix helper
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/ryder/nixos-config";
    };
  };
}

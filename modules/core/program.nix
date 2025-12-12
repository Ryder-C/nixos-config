{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nix-citizen.nixosModules.default];
  programs = {
    thunar.enable = true;
    dconf.enable = true;
    fish.enable = true;
    zsh.enable = true;
    rsi-launcher = {
      enable = false;
      disableEAC = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryFlavor = "";
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
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXfixes
      xorg.libXinerama
      xorg.libXi
      xorg.libXrandr
      xorg.libXScrnSaver
      xorg.libXtst
      xorg.xcbutil
      xorg.xcbutilimage
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      xorg.xcbutilkeysyms
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

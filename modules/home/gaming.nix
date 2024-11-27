{
  pkgs,
  config,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    ## Utils
    # gamemode
    # gamescope
    winetricks
    inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    (inputs.nix-gaming.packages.${pkgs.system}.star-citizen.override (prev: {
      # wineDllOverrides = prev.wineDllOverrides ++ [ "dxgi=n" ];
      tricks = ["arial" "vcrun2019" "win10" "sound=alsa"];
    }))
    mangohud

    ## Minecraft
    prismlauncher

    ## Cli games
    _2048-in-terminal
    vitetris
    nethack

    ## Celeste
    # celeste-classic
    # celeste-classic-pm

    ## Doom
    # gzdoom
    # crispy-doom

    ## Emulation
    # sameboy
    # snes9x
    # cemu
    # dolphin-emu

    ## Lutris
    lutris
    (lutris.override {
      extraLibraries = pkgs: [
      ];
    })
  ];
}

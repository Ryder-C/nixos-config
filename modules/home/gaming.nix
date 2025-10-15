{
  pkgs,
  stablePkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    ## Utils
    # gamemode
    # gamescope
    winetricks
    # inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    # (inputs.nix-gaming.packages.${pkgs.system}.star-citizen.override (prev: {
    #   # wineDllOverrides = prev.wineDllOverrides ++ [ "dxgi=n" ];
    #   tricks = ["arial" "vcrun2019" "win10" "sound=alsa"];
    # }))
    # inputs.nix-citizen.packages.${system}.star-citizen
    inputs.nix-citizen.packages.${system}.lug-helper
    mangohud

    ## Minecraft
    stablePkgs.prismlauncher

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
    # If you had any overrides for Lutris, you can adjust them accordingly
    # (lutris.override {
    #   extraLibraries = _pkgs: [
    #     gst_all_1.gstreamer
    #     gst_all_1.gst-plugins-good
    #     gst_all_1.gst-libav
    #     gst_all_1.gst-plugins-rs
    #     gst_all_1.gst-plugins-base
    #     libslirp
    #     libarchive
    #     vulkan-loader
    #     vulkan-tools
    #     icu
    #   ];
    # })
    stablePkgs.lutris
  ];
  home.sessionVariables = {
    # VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.json";
  };
}

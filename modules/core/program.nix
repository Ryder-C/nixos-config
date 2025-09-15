{pkgs, ...}: {
  programs = {
    dconf.enable = true;
    fish.enable = true;
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryFlavor = "";
    };
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      icu
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

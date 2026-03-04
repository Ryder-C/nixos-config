_: {
  ry.system-x86.nixos = {config, pkgs, lib, ...}:
    lib.mkIf config._ry.isX86 {
    nix.settings = {
      substituters = [
        "https://nix-gaming.cachix.org"
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };

    environment.systemPackages = with pkgs; [
      bcachefs-tools
      openrgb-with-all-plugins
      appimage-run
      steam-run
    ];

    services.udev.packages = [pkgs.via];
  };
}

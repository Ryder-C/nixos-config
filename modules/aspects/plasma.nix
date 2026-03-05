_: {
  ry.plasma.homeManager = {pkgs, ...}: {
    programs.mpv = {
      enable = true;
    };
  };

  ry.plasma.nixos = {pkgs, ...}: {
    services.desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = false;
    };

    programs.kdeconnect.enable = false;

    environment = {
      # Disable kwallet completely
      etc."xdg/kwalletrc".text = ''
        [Wallet]
        Enabled=false
      '';

      sessionVariables = {
        # Disable kwallet daemon
        KWALLETD_ENABLED = "false";
        # Enable HDR for Vulkan
        ENABLE_HDR_WSI = "1";
      };

      systemPackages = with pkgs; [
        vulkan-hdr-layer-kwin6
      ];

      # Exclude as many KDE packages as possible for minimal setup
      plasma6.excludePackages = with pkgs.kdePackages; [
        baloo
        discover
        drkonqi
        elisa
        gwenview
        kate
        khelpcenter
        kinfocenter
        kmailtransport
        konsole
        krdp
        kwallet
        kwalletmanager
        okular
        oxygen
        plasma-browser-integration
        plasma-welcome
        print-manager
      ];
    };
  };
}

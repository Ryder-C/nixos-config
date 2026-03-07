_: {
  ry.plasma.homeManager = {pkgs, ...}: {
    programs.mpv = {
      enable = true;
    };

    services.jellyfin-mpv-shim = {
      enable = true;
      settings = {
        fullscreen = true;
        transcode_hdr = false;
      };
      mpvConfig = {
        vo = "gpu-next";
        target-colorspace-hint = true;
        gpu-api = "vulkan";
        gpu-context = "waylandvk";

        target-trc = "pq";
        target-prim = "bt.2020";
        target-peak = "1000";
        hdr-compute-peak = "no";
      };
    };

    # Only start jellyfin-mpv-shim when logged into Plasma
    systemd.user.services.jellyfin-mpv-shim.Service.ExecCondition = "${pkgs.bash}/bin/bash -c '[ \"$XDG_CURRENT_DESKTOP\" = \"KDE\" ]'";
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
        KWALLETD_ENABLED = "false";
      };

      # Only set in Plasma sessions — breaks GNOME portal screencast on niri
      etc."xdg/plasma-workspace/env/hdr.sh".text = ''
        export ENABLE_HDR_WSI=1
      '';

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

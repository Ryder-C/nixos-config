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
        remote_kbps = 2147483;
        discord_presence = true;
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
    # Disable the HDR WSI layer so mpv can create its own HDR swapchain directly
    systemd.user.services.jellyfin-mpv-shim.Service = {
      ExecCondition = "${pkgs.bash}/bin/bash -c '[ \"$XDG_CURRENT_DESKTOP\" = \"KDE\" ]'";
      Environment = "ENABLE_HDR_WSI=0";
    };
  };

  ry.plasma.nixos = {pkgs, ...}: {
    services.desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = false;
    };

    # drkonqi's coredump processor itself segfaults, creating a feedback loop
    # via systemd-coredump@.service.wants/. Suppressing the unit is the only
    # reliable way — plasma6.excludePackages doesn't drop the systemd unit.
    systemd.suppressedSystemUnits = ["drkonqi-coredump-processor@.service"];

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

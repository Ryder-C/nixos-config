_: {
  ry.virtualization.nixos = {pkgs, ...}: {
    users.users.ryder = {
      extraGroups = ["libvirtd"];
      linger = true;
    };
    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin:/run/wrappers/bin:${pkgs.lib.makeBinPath [pkgs.bash pkgs.shadow]}"
    '';

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      virtio-win
      win-spice
      adwaita-icon-theme

      android-tools
      iptables

      nur.repos.ataraxiasjel.waydroid-script
    ];

    programs.virt-manager.enable = true;

    virtualisation = {
      waydroid = {
        enable = true;
        package = pkgs.waydroid-nftables;
      };
      containers.enable = true;
      docker = {
        enable = true;
        autoPrune.enable = true;
      };
      oci-containers.backend = "docker";
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
      };
      spiceUSBRedirection.enable = true;
    };

    services.spice-vdagentd.enable = true;
  };
}

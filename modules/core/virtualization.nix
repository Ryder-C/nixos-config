{
  pkgs,
  username,
  ...
}: {
  # Add user to libvirtd group
  users.users.${username} = {
    extraGroups = ["libvirtd" "podman"];
    linger = true;
  };
  systemd = {
    user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin:/run/wrappers/bin:${pkgs.lib.makeBinPath [pkgs.bash pkgs.shadow]}"
    '';
    generators.podman = "${pkgs.podman}/libexec/podman/systemd-generator";
  };

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    adwaita-icon-theme
    podman
    podman-tui
  ];

  programs.virt-manager.enable = true;

  # Manage the virtualisation services
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      autoPrune.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}

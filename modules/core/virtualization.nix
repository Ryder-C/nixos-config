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
    virtio-win
    win-spice
    adwaita-icon-theme
    podman
    podman-tui

    waydroid
    android-tools
    iptables
  ];

  networking.networkmanager.unmanaged = ["interface-name:waydroid*"];

  programs = {
    virt-manager.enable = true;
    adb.enable = true;
  };

  # Manage the virtualisation services
  virtualisation = {
    waydroid.enable = true;
    containers.enable = true;
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    oci-containers.backend = "docker";
    podman = {
      enable = false;
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
  services = {
    spice-vdagentd.enable = true;
  };
}

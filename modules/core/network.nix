{pkgs, ...}: {
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443 3000 32400 59010 59011];
      allowedUDPPorts = [32410 32412 32413 32414 59010 59011];
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

  # Ensure network-online.target is meaningful and waits for NetworkManager connectivity
  # This enables the NetworkManager-wait-online.service unit
  systemd.services.NetworkManager-wait-online.enable = true;

  # Use systemd-resolved for DNS and integrate with NetworkManager
  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
}

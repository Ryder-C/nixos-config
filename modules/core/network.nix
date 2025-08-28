{pkgs, ...}: {
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # Let NetworkManager manage DNS (remove crab-hole local resolver)
    # You can set DNS via NM if desired, or leave automatic
    # nameservers = ["1.1.1.1" "1.0.0.1"]; # optional
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443 47984 47989 48010 59010 59011];
      allowedUDPPorts = [47998 47999 48000 59010 59011];
      # allowedUDPPortRanges = [
      # { from = 4000; to = 4007; }
      # { from = 8000; to = 8010; }
      # ];
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

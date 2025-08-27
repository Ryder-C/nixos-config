{pkgs, ...}: {
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = [
      # "1.1.1.1"

      # --- Configure NixOS to use the local crab-hole instance ---
      "127.0.0.1" # Use local IPv4 address first
      "::1" # Use local IPv6 address as fallback
    ];
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
}

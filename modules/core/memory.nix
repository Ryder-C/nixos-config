_: {
  # Zram
  zramSwap.enable = true;

  # Swap
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024; # 8 GB Swap
    }
  ];
}

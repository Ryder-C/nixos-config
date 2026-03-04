_: {
  ry.memory.nixos = {
    zramSwap.enable = true;
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 8 * 1024; # 8 GB Swap
      }
    ];
  };
}

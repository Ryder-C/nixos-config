{...}: {
  # Placeholder hardware configuration for Fornax
  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  nixpkgs.hostPlatform = "x86_64-linux";
}

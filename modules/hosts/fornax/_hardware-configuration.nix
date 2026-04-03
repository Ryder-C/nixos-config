_: {
  # Placeholder hardware configuration for Fornax
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "nvme" "ahci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };
  nixpkgs.hostPlatform = "x86_64-linux";
}

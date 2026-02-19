# Placeholder hardware configuration for M1 MacBook Pro (Asahi Linux)
# Regenerate on the actual hardware with: nixos-generate-config --show-hardware-config
{
  inputs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    inputs.apple-silicon-support.nixosModules.apple-silicon-support
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
  };

  # TODO: Replace these with actual UUIDs from nixos-generate-config
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/PLACEHOLDER";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/PLACEHOLDER";
    fsType = "vfat";
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  hardware.asahi = {
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
  };
}

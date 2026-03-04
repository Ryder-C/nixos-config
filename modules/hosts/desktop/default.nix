{ry, ...}: {
  den.aspects.desktop = {
    includes = [ry.x86-workstation];

    nixos = {config, ...}: {
      imports = [./_hardware-configuration.nix];

      _ry.isX86 = true;
      _ry.hasNvidia = true;

      powerManagement.cpuFreqGovernor = "performance";
      boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
      boot.kernelModules = [
        "v4l2loopback"
        "wacom"
      ];

      # Nvidia High VRAM usage fix for Niri (and other Wayland compositors)
      # https://yalter.github.io/niri/Nvidia.html#high-vram-usage-fix
      environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text = ''
        {
          "rules": [
            {
              "pattern": {
                "feature": "procname",
                "matches": "niri"
              },
              "profile": "Limit Free Buffer Pool On Wayland Compositors"
            }
          ],
          "profiles": [
            {
              "name": "Limit Free Buffer Pool On Wayland Compositors",
              "settings": [
                {
                  "key": "GLVidHeapReuseRatio",
                  "value": 0
                }
              ]
            }
          ]
        }
      '';
    };
  };
}

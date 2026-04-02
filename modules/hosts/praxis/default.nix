{ry, ...}: {
  den.aspects.praxis = {
    includes = [
      ry.workstation
      ry.niri-praxis
      ry.greetd-praxis
      ry.desktop-tools
      ry.nvidia
      ry.steam
      ry.torrents
      ry.ollama
      ry.rgb
      ry.nixarr
      ry.star-citizen
      ry.aagl
      ry.bluevein
      ry.spicetify
      ry.activitywatch
      ry.librepods
      ry.flatpak
      ry.tailscale
    ];

    nixos = {
      config,
      pkgs,
      ...
    }: {
      imports = [./_hardware-configuration.nix];

      powerManagement.cpuFreqGovernor = "performance";

      boot = {
        supportedFilesystems = ["bcachefs"];
        kernelPackages = pkgs.linuxPackages_zen;
        extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
        kernelModules = [
          "v4l2loopback"
          "wacom"
        ];
      };

      hardware = {
        flipperzero.enable = true;
        steam-hardware.enable = true;
        opentabletdriver.enable = true;
        graphics.enable32Bit = true;
      };

      # disable ghost MediaTek bluetooth adapter (0e8d:0616) on desktop
      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", ATTR{idProduct}=="0616", ATTR{authorized}="0"
      '';

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

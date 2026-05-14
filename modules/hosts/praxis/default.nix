{
  inputs,
  ry,
  ...
}: {
  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  den.aspects.praxis = {
    includes = [
      ry.workstation
      ry.plasma
      ry.gaming
      ry.niri-praxis
      ry.noctalia-praxis
      ry.desktop-tools
      ry.nvidia
      ry.steam
      ry.torrents
      # ry.ollama
      # ry.openclaw
      ry.rgb
      # ry.star-citizen
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

      nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.default];

      nix.settings = {
        substituters = ["https://attic.xuyh0120.win/lantian"];
        trusted-public-keys = ["lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
      };

      powerManagement.cpuFreqGovernor = "performance";

      boot = {
        kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
        extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
        kernelModules = [
          "v4l2loopback"
          "wacom"
        ];
        extraModprobeConfig = ''
          options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1
        '';
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

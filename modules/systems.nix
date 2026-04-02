{ry, ...}: {
  ry = {
    # Fundamental CLI-only aspects (Server, VM, Desktop)
    base.includes = [
      ry.network
      ry.programs
      ry.security
      ry.services
      ry.system
      ry.secrets
      ry.memory
      ry.bootloader
      ry.terminal
      ry.shell
      ry.editor
      ry.development
      ry.packages
    ];

    # Base workstation aspects (adds minimal GUI/Desktop)
    workstation-base.includes = [
      ry.base
      ry.bluetooth
      ry.audio
      ry.wayland
      ry.greetd
      ry.virtualization
      ry.hardware
      ry.media-apps
    ];

    # Full desktop aspects (extends base)
    workstation.includes = [
      ry.workstation-base

      ry.niri
      ry.plasma
      ry.noctalia
      ry.browser
      ry.discord
      ry.catppuccin
      ry.scripts
      ry.home-services
      ry.gaming
    ];
  };
}

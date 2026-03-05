{ry, ...}: {
  ry = {
    # Base aspects shared by all hosts (including VM)
    workstation-base.includes = [
      ry.bootloader
      ry.network
      ry.bluetooth
      ry.audio
      ry.programs
      ry.security
      ry.services
      ry.system
      ry.wayland
      ry.virtualization
      ry.secrets
      ry.greetd
      ry.memory
      ry.hardware

      # Minimal home aspects (VM-compatible)
      ry.terminal
      ry.shell
      ry.editor
      ry.development
      ry.packages
      ry.media-apps
    ];

    # Full desktop aspects (extends base)
    workstation.includes = [
      ry.workstation-base

      ry.niri
      ry.plasma
      ry.dank
      ry.browser
      ry.discord
      ry.catppuccin
      ry.scripts
      ry.home-services
      ry.gaming
    ];
  };
}

{...}: {
  imports = [
    # ./aseprite/aseprite.nix # pixel art editor
    # ./audacious/audacious.nix # music player
    ./bat.nix # better cat command
    ./btop.nix # resouces monitor
    ./ssh.nix
    ./services.nix
    ./cava.nix # audio visualizer
    ./discord.nix # discord with catppuccin theme
    # ./podman.nix
    ./browser.nix # firefox based browser
    ./fuzzel.nix # launcher
    ./gaming.nix # packages related to gaming
    ./git.nix # version control
    ./gtk.nix # gtk theme
    ./hyprland # window manager
    # ./kitty.nix # terminal
    # ./wezterm.nix
    ./alacritty.nix
    # ./ghostty.nix
    ./tmux.nix
    # ./fastfetch.nix
    ./swaync/swaync.nix # notification deamon
    ./micro.nix # nano replacement
    # ./helix.nix
    ./nvim.nix # neovim
    ./packages.nix # other packages
    # ./retroarch.nix
    ./scripts/scripts.nix # personal scripts
    ./spicetify.nix # spotify client
    ./starship.nix # shell prompt
    ./swaylock.nix # lock screen
    # ./vscodium.nix # vscode fork
    ./waybar # status bar
    ./zsh.nix # shell
  ];
}

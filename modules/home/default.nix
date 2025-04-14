{
  inputs,
  stablePackages,
  username,
  host,
  ...
}: {
  # imports =
  #   # [(import ./aseprite/aseprite.nix)] # pixel art editor
  #   # ++ [(import ./audacious/audacious.nix)] # music player
  #   [(import ./bat.nix)] # better cat command
  #   ++ [(import ./btop.nix)] # resouces monitor
  #   ++ [(import ./ssh.nix)]
  #   ++ [(import ./services.nix)]
  #   ++ [(import ./cava.nix)] # audio visualizer
  #   ++ [(import ./discord.nix)] # discord with catppuccin theme
  #   # ++ [(import ./podman.nix)]
  #   ++ [(import ./browser.nix)] # firefox based browser
  #   ++ [(import ./fuzzel.nix)] # launcher
  #   ++ [(import ./gaming.nix)] # packages related to gaming
  #   ++ [(import ./git.nix)] # version control
  #   ++ [(import ./gtk.nix)] # gtk theme
  #   ++ [(import ./hyprland)] # window manager
  #   ++ [(import ./kitty.nix)] # terminal
  #   # ++ [(import ./wezterm.nix)]
  #
  #   ++ [(import ./swaync/swaync.nix)] # notification deamon
  #   ++ [(import ./micro.nix)] # nano replacement
  #   ++ [(import ./helix.nix)]
  #   ++ [(import ./packages.nix)] # other packages
  #   # ++ [(import ./retroarch.nix)]
  #   ++ [(import ./scripts/scripts.nix)] # personal scripts
  #   ++ [(import ./spicetify.nix)] # spotify client
  #   ++ [(import ./starship.nix)] # shell prompt
  #   ++ [(import ./swaylock.nix)] # lock screen
  #   # ++ [(import ./vscodium.nix)] # vscode fork
  #   ++ [(import ./waybar)] # status bar
  #   ++ [(import ./zsh.nix)]; # shell
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
    ./wezterm.nix
    ./ghostty.nix
    ./swaync/swaync.nix # notification deamon
    ./micro.nix # nano replacement
    ./helix.nix
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

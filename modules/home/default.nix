{inputs, ...}: {
  imports = [
    inputs.niri.homeModules.niri
    inputs.catppuccin.homeModules.catppuccin

    ./bat.nix
    ./btop.nix
    ./ssh.nix
    ./services.nix
    ./cava.nix
    ./discord.nix
    ./development.nix
    ./browser.nix
    ./gaming.nix
    ./git.nix
    ./gtk.nix
    ./niri
    ./alacritty.nix
    ./zellij.nix
    ./micro.nix
    ./helix.nix
    ./nvim.nix
    ./packages.nix
    ./scripts/scripts.nix
    ./spicetify.nix
    ./starship.nix
    ./dank.nix
    ./yazi.nix
    ./fish.nix
  ];

  catppuccin = {
    enable = true;
    cache.enable = true;
    accent = "mauve";
    flavor = "mocha";

    cursors.enable = true;
  };

  # Symlink the Catppuccin Stylus JSON (flake input, non-flake URL pinned in lockfile) into the home directory
  home.file."catppuccin_styles.json".source = inputs.catppuccin-stylus-json;

  # Ensure terminal applications use Neovim by default
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}

{inputs, host, lib, ...}: {
  imports = [
    inputs.niri.homeModules.niri
    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.nix-index

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
    ./starship.nix
    ./dank.nix
    ./yazi.nix
    ./fish.nix
  ] ++ lib.optionals (host != "laptop") [
    ./spicetify.nix
    ./gpu-screen-recorder.nix
    ./activitywatch.nix
    ./librepods.nix
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

  # nix-index with comma - run any command without installing
  programs.nix-index-database.comma.enable = true;
}

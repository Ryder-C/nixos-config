{...}: {
  imports = [
    ./bat.nix
    ./btop.nix
    ./ssh.nix
    ./development.nix
    ./git.nix
    ./alacritty.nix
    ./zellij.nix
    ./micro.nix
    ./helix.nix
    ./nvim.nix
    ./packages.nix
    ./starship.nix
    ./fish.nix
  ];

  # Ensure terminal applications use Neovim by default
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}

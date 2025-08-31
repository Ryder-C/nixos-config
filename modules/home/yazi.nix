{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-yazi-plugins.legacyPackages.x86_64-linux.homeManagerModules.default
  ];

  programs.yazi = {
    enable = true;
    plugins = with pkgs.yaziPlugins; {inherit yatline-catppuccin rich-preview;};
    settings = {
      opener = {
        edit = [
          {
            run = "nvim \"$@\"";
            block = true;
            for = "unix";
          }
        ];
      };
    };
    yaziPlugins = {
      enable = true;
      plugins = {
        starship.enable = true;
        jump-to-char = {
          enable = true;
          keys.toggle.on = ["F"];
        };
        bookmarks.enable = true;
      };
    };
  };
}

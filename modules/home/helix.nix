{
  pkgs,
  inputs,
  ...
}: {
  # LSPs
  home.packages = with pkgs; [
    nil
  ];

  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = "alejandra";
          args = ["-q"];
        };
      }
    ];
    themes = {
      catppuccin_mocha =
        {
          "inherits" = "catppuccin_mocha";
        }
        // builtins.fromTOML (builtins.readFile "${inputs.catppuccin-helix}/themes/default/catppuccin_mocha.toml");
    };
  };
}

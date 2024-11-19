{
  pkgs,
  inputs,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      nil
      tinymist
    ];
    settings = {
      theme = "catppuccin_mocha";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };

    languages = {
      language-server.tinymist = {
        command = "tinymist";
        config = {
          exportPdf = "onType";
          outputPath = "$root/out/$name";
        };
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "alejandra";
            args = ["-q"];
          };
        }
        {
          name = "typst";
          language-servers = ["tinymist"];
        }
      ];
    };

    themes = {
      catppuccin_mocha =
        {
          "inherits" = "catppuccin_mocha";
        }
        // builtins.fromTOML (builtins.readFile "${inputs.catppuccin-helix}/themes/default/catppuccin_mocha.toml");
    };
  };
}

{pkgs, ...}: {
  programs.helix = {
    enable = true;
    # defaultEditor = true;
    extraPackages = with pkgs; [
      # LSPs
      nil
      tinymist
      rust-analyzer-unwrapped

      # Formatters
      typstyle

      # Debuggers
      lldb_19
    ];
    settings = {
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };

      # Colemak-DH mappings
      keys = {
        normal = {
          n = "move_char_left";
          e = "move_line_down";
          i = "move_line_up";
          o = "move_char_right";

          h = "insert_mode";
          H = "insert_at_line_start";

          l = "open_below";
          L = "open_above";

          k = "move_next_word_end";
          K = "move_next_long_word_end";

          j = "search_next";
          J = "search_prev";

          g = {
            n = "goto_line_start";
            o = "goto_line_end";
          };

          space.w = {
            n = "jump_view_left";
            e = "jump_view_down";
            i = "jump_view_up";
            o = "jump_view_right";
          };

          C-w = {
            n = "jump_view_left";
            e = "jump_view_down";
            E = "join_selections";
            "A-E" = "join_selections_space";

            i = "jump_view_up";
            I = "keep_selections";
            "A-I" = "remove_selections";

            o = "jump_view_right";
          };

          z = {
            e = "scroll_down";
            i = "scroll_up";
          };

          Z = {
            e = "scroll_down";
            i = "scroll_up";
          };
        };

        insert."A-x" = "normal_mode";

        select = {
          n = "move_char_left";
          e = "move_line_down";
          i = "move_line_up";
          o = "move_char_right";

          h = "insert_mode";
          H = "insert_at_line_start";

          l = "open_below";
          L = "open_above";

          k = "move_next_word_end";
          K = "move_next_long_word_end";

          j = "search_next";
          J = "search_prev";
        };
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
          name = "rust";
          auto-format = true;
        }
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
          auto-format = true;
          formatter = {
            command = "typstyle";
            args = ["-i"];
          };
          language-servers = ["tinymist"];
          soft-wrap.enable = true;
        }
      ];
    };
  };
}

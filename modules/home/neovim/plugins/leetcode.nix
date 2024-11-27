{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs.vimPlugins; [
      leetcode-nvim
    ];
  };

  home.file.".leetcode/leetcode.toml".text = ''
    [code]
    editor = 'nvim'
    lang = 'rust'
    comment_problem_desc = false
    comment_leading = "//"
    test = true

    [cookies]
    csrf = "1mwu8r0g8fCNPIqUwXfi8QCVlVbgNWBDT6MAkb4Y7nzP1aY3iQiRoF4X9HbdWJaT"
    session = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfYXV0aF91c2VyX2lkIjoiNDU1MjMwMiIsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImFsbGF1dGguYWNjb3VudC5hdXRoX2JhY2tlbmRzLkF1dGhlbnRpY2F0aW9uQmFja2VuZCIsIl9hdXRoX3VzZXJfaGFzaCI6IjhhZmVkN2JkY2JkNzA1OWFiYjQ3YjJmMjU4ZTZhOGM4MmMxNjAxYzc4ZDBiMTEwMjg0YjU1YjNhMmRlNjg3MzAiLCJpZCI6NDU1MjMwMiwiZW1haWwiOiJyeWRlcmNhc2F6emFAZ21haWwuY29tIiwidXNlcm5hbWUiOiJTcG9yazEwMjMiLCJ1c2VyX3NsdWciOiJTcG9yazEwMjMiLCJhdmF0YXIiOiJodHRwczovL2Fzc2V0cy5sZWV0Y29kZS5jb20vdXNlcnMvYXZhdGFycy9hdmF0YXJfMTcwNzQ0MzIwMi5wbmciLCJyZWZyZXNoZWRfYXQiOjE3MzIyMjEzNDIsImlwIjoiMTI4LjExNC4yNTUuMTI2IiwiaWRlbnRpdHkiOiJiMWIwMjhhZWNmZjU2MjkwYmI3NDdmNDJjNTVjOGYzYSIsInNlc3Npb25faWQiOjE0Nzc2OTMsImRldmljZV93aXRoX2lwIjpbIjlkOWE4ZjRiMzkwMzdjMGRmYTBlOWIxYmY5N2QwNzZjIiwiMTI4LjExNC4yNTUuMTI2Il19.ztwMSut9tLdZsOTJ2tmjMl6lJ1DUzpSU7SRTDqHWk3g"
    site = "leetcode.com"

    [storage]
    cache = "Problems"
    code = "code"
    root = "~/.leetcode"
    scripts = "scripts"
  '';
}

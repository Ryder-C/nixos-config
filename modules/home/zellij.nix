{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      theme = "catppuccin-mocha";
      session_serialization = false;
    };
  };
}

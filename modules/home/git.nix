{pkgs, ...}: {
  programs.git = {
    enable = true;

    userName = "Ryder-C";
    userEmail = "rydercasazza@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };

  programs.lazygit = {
    enable = true;

    settings.gui = {
      theme = {
        activeBorderColor = ["#cba6f7" "bold"];
        inactiveBorderColor = ["#a6adc8"];
        optionsTextColor = ["#89b4fa"];
        selectedLineBgColor = ["#313244"];
        cherryPickedCommitBgColor = ["#45475a"];
        cherryPickedCommitFgColor = ["#cba6f7"];
        unstagedChangesColor = ["#f38ba8"];
        defaultFgColor = ["#cdd6f4"];
        searchingActiveBorderColor = ["#f9e2af"];
      };

      authorColors = {
        "*" = "#b4befe";
      };
    };
  };

  home.packages = [pkgs.gh pkgs.git-lfs];
}

{ pkgs, ... }: 
{
  programs.git = {
    enable = true;
    
    userName = "Ryder-C";
    userEmail = "rydercasazza@gmail.com";
    
    extraConfig = { 
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };

  home.packages = [ pkgs.gh pkgs.git-lfs ];
}

{...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:weight=bold:size=14";
        line-height = 25;
        fields = "name,generic,comment,categories,filename,keywords";
        terminal = "alacritty";
        prompt = "' ➜  '";
        icon-theme = "Papirus-Dark";
        layer = "top";
        lines = 10;
        width = 35;
        horizontal-pad = 25;
        inner-pad = 5;
      };
      border = {
        radius = 15;
        width = 3;
      };
    };
  };
}

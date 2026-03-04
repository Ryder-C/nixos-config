_: {
  ry.browser.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      brave
    ];

    programs.librewolf.enable = true;

    home.sessionVariables = {
      BROWSER = "brave";
    };
  };
}

{
  inputs,
  pkgs,
  host,
  ...
}: {
  home.packages = with pkgs; [
    # (
    #   if (host == "laptop")
    #   then inputs.zen-browser.packages."${system}".generic
    #   else inputs.zen-browser.packages."${system}".specific
    # )
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
  home.sessionVariables = {
    BROWSER = "${inputs.zen-browser.packages.${pkgs.system}.default}";
  };
}

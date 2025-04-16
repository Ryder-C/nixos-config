{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.nixvim.packages.${system}.default
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}

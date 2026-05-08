{inputs, ...}: {
  flake-file.inputs.helium = {
    url = "github:schembriaiden/helium-browser-nix-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.browser.homeManager = {
    pkgs,
    lib,
    isLinux,
    ...
  }: {
    home.packages = with pkgs; [
      brave
      inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium
    ];

    home.sessionVariables = {
      BROWSER = "helium";
    };

    xdg.mimeApps = lib.mkIf isLinux {
      enable = true;
      defaultApplications = {
        "text/html" = "helium.desktop";
        "x-scheme-handler/http" = "helium.desktop";
        "x-scheme-handler/https" = "helium.desktop";
        "x-scheme-handler/about" = "helium.desktop";
        "x-scheme-handler/unknown" = "helium.desktop";
      };
    };
  };
}

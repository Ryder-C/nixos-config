{inputs, ...}: {
  flake-file.inputs.helium = {
    url = "github:schembriaiden/helium-browser-nix-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.browser.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      brave
      inputs.helium.packages.${system}.helium
    ];

    home.sessionVariables = {
      BROWSER = "helium";
    };

    xdg.mimeApps = {
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

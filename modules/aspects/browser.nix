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
  }: let
    helium-upstream = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium;
    # Pin the Chromium password backend so it doesn't flip between
    # gnome-libsecret (niri) and kwallet (Plasma) — see plasma.nix where
    # kwallet is disabled; without this, switching DEs corrupts the per-profile
    # encryption key and wipes logins/cookies.
    helium = pkgs.symlinkJoin {
      name = "helium-wrapped-${helium-upstream.version}";
      paths = [helium-upstream];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/helium \
          --add-flags "--password-store=gnome-libsecret"
      '';
      inherit (helium-upstream) meta;
    };
  in {
    home.packages = with pkgs; [
      brave
      helium
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

_: {
  # Single owner for "what opens what". Individual aspects install the apps;
  # the associations all live here so they can't disagree.
  ry.xdg.homeManager = {
    lib,
    isLinux,
    ...
  }:
    lib.mkIf isLinux {
      xdg = {
        mimeApps = {
          enable = true;
          defaultApplications = {
            "inode/directory" = ["thunar.desktop"];
            "text/html" = "helium.desktop";
            "x-scheme-handler/http" = "helium.desktop";
            "x-scheme-handler/https" = "helium.desktop";
            "x-scheme-handler/about" = "helium.desktop";
            "x-scheme-handler/unknown" = "helium.desktop";
          };
        };

        # HM refuses to overwrite a mimeapps.list that apps have rewritten.
        dataFile."applications/mimeapps.list".force = true;
      };
    };
}

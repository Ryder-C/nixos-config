{pkgs}: let
  runtimeDeps = with pkgs; [
    jq
    libnotify
  ];
in
  pkgs.writeShellScriptBin "toggle-hdr" ''
    export PATH=${pkgs.lib.makeBinPath runtimeDeps}:$PATH

    ${builtins.readFile ./toggle_hdr.sh}
  ''

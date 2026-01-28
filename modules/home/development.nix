{
  pkgs,
  stablePkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.claude-code.overlays.default];

  home.packages = with pkgs; [
    devenv
    vscode
    # kicad
    (stablePkgs.blender.override {cudaSupport = true;})
    obs-studio
    antigravity
    claude-code

    typst
    typstyle
    inputs.alejandra.defaultPackage.${pkgs.system}
  ];

  programs = {
    direnv.enable = true;
  };

  # Automatically load direnv when entering a directory
  # programs.nushell.extraConfig = ''
  #   $env.config.hooks.env_change.PWD = (
  #     $env.config.hooks.env_change.PWD | append ({ ||
  #       if (which direnv | is-empty) {
  #         return
  #       }
  #
  #       direnv export json | from json | default {} | load-env
  #       $env.PATH = $env.PATH | split row (char env_sep)
  #     })
  #   )
  # '';
}

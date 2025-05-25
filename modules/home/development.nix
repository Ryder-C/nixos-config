{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
  ];

  programs.direnv.enable = true;

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

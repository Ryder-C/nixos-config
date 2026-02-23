{
  pkgs,
  stablePkgs,
  inputs,
  host,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      devenv
      vscode
      obs-studio

      # Languages & toolchains
      nodejs
      (rust-bin.stable.latest.default.override {
        extensions = [
          "rust-src"
          "rustfmt"
          "clippy"
        ];
        targets = [
          (
            if pkgs.stdenv.hostPlatform.isAarch64
            then "aarch64-unknown-linux-gnu"
            else "x86_64-unknown-linux-gnu"
          )
        ];
      })
      rust-analyzer

      # GPU debugging
      mesa-demos
      vulkan-tools

      typst
      typstyle
      inputs.alejandra.defaultPackage.${pkgs.stdenv.hostPlatform.system}
    ]
    ++ lib.optionals (host != "laptop") [
      (stablePkgs.blender.override {cudaSupport = true;})
    ]
    ++ lib.optionals (host == "laptop") [
      stablePkgs.blender
    ];

  programs = {
    zed-editor.enable = true;
    claude-code = {
      enable = true;
      package = pkgs.claude-code;
    };
    gemini-cli = {
      enable = true;
      settings = {
        general = {
          preferredEditor = "nvim";
          previewFeatures = true;
        };

        experimental.plan = true;
      };
    };
    opencode.enable = true;
    direnv.enable = true;
  };
}

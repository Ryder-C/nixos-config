{
  pkgs,
  stablePkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    devenv
    vscode
    (stablePkgs.blender.override {cudaSupport = true;})
    obs-studio

    # Languages & toolchains
    nodejs
    (rust-bin.stable.latest.default.override {
      extensions = [
        "rust-src"
        "rustfmt"
        "clippy"
      ];
      targets = ["x86_64-unknown-linux-gnu"];
    })
    rust-analyzer

    # GPU debugging
    mesa-demos
    vulkan-tools

    typst
    typstyle
    inputs.alejandra.defaultPackage.${pkgs.stdenv.hostPlatform.system}
  ];

  programs = {
    zed-editor.enable = true;
    claude-code = {
      enable = true;
      package = pkgs.claude-code;
    };
    gemini-cli.enable = true;
    opencode.enable = true;
    direnv.enable = true;
  };
}

{inputs, ...}: {
  flake-file.inputs.wayscriber = {
    url = "github:devmobasa/wayscriber";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.wayscriber.homeManager = {pkgs, ...}: {
    programs.niri.settings.binds."Mod+D".action.spawn = ["${inputs.wayscriber.packages.${pkgs.stdenv.hostPlatform.system}.default}" "--active"];
  };
}

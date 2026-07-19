{inputs, ...}: {
  flake-file.inputs.wayscriber = {
    url = "github:devmobasa/wayscriber";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ry.wayscriber.homeManager = {pkgs, ...}: let
    # wayscriber's test suite is sandbox-hostile: it spawns daemon processes,
    # probes caller-PID liveness, and races reading fixture-report files, so
    # different tests fail non-deterministically under `nix build`. 1b2d204 is
    # already upstream HEAD, so disable the check phase to build the binary.
    wayscriber = inputs.wayscriber.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
      doCheck = false;
    });
  in {
    programs.niri.settings.binds."Mod+D".action.spawn = ["${wayscriber}/bin/wayscriber" "--active"];
  };
}

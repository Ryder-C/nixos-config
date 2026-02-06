{
  pkgs,
  stablePkgs,
  inputs,
  username,
  host,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {inherit inputs username host stablePkgs;};
    users.${username} = {
      imports =
        if (host == "desktop")
        then [./../home/default.desktop.nix]
        else if (host == "vm")
        then [./../home/default.vm.nix]
        else [./../home];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
      };
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = ["networkmanager" "wheel" "dialout" "input" "uinput" "seat" "docker"];
    shell = pkgs.fish;
  };
  nix.settings.allowed-users = ["${username}"];
}

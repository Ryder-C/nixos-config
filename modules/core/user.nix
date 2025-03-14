{
  pkgs,
  inputs,
  username,
  host,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs username host;};
    users.${username} = {
      imports =
        if (host == "desktop")
        then [./../home/default.desktop.nix]
        else [./../home];
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "24.05";
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
  nix.settings.allowed-users = ["${username}"];

  # See https://github.com/starcitizen-lug/knowledge-base/wiki/Manual-Installation#prerequisites
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  # See RAM, ZRAM & Swap
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024; # 8 GB Swap
    }
  ];
  zramSwap = {
    enable = true;
    memoryMax = 32 * 1024 * 1024 * 1024; # 32 GB ZRAM
  };
}

{
  programs.fastfetch = {
    enable = true;

    settings = {
      modules = [
        "title"
        {
          type = "datetime";
          key = "Timestamp";
          format = "{1}-{3}-{11} {14}:{17}:{20}";
        }
        "Uptime"
        "separator"
        "Kernel"
        "OS"
        {
          type = "command";
          key = "NixOS Gen";
          text = "nix-env --list-generations | tail -n1 | awk '{print $1}'";
        }
        "Break"
        "Board"
        "CPU"
        "GPU"
        "Memory"
        "Disk"
        "Break"
        "Colors"
      ];
    };
  };
}

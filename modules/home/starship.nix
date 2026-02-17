{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.jj-starship.packages.${pkgs.stdenv.hostPlatform.system}.jj-starship
  ];

  programs.starship = {
    enable = true;

    settings = {
      directory = {
        format = "[ ](bold #89b4fa)[ $path ]($style)";
        style = "bold #b4befe";
      };

      character = {
        success_symbol = "[ ](bold #89b4fa)[ ➜](bold green)";
        error_symbol = "[ ](bold #89b4fa)[ ➜](bold red)";
      };

      cmd_duration = {
        format = "[󰔛 $duration]($style)";
        disabled = false;
        style = "bg:none fg:#f9e2af";
        show_notifications = false;
        min_time_to_notify = 60000;
      };

      custom.jj = {
        when = "jj-starship detect";
        command = "JJ_STARSHIP_JJ_SYMBOL='󱗆 ' jj-starship";
        format = "$output ";
      };

      git_branch.disabled = true;
      git_commit.disabled = true;
      git_status.disabled = true;
    };
  };
}

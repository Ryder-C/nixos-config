{pkgs, ...}: {
  home.packages = with pkgs; [
    wttrbar
  ];

  programs.waybar.settings.mainBar = {
    position = "top";
    layer = "top";
    height = 30;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
    ];
    modules-center = [
      "clock"
      "custom/weather"
    ];
    modules-right = [
      "tray"
      "cpu"
      "memory"
      "disk"
      "pulseaudio"
      "battery"
      "network"
      "custom/notification"
    ];
    clock = {
      calendar = {
        format = {today = "<span color='#b4befe'><b><u>{}</u></b></span>";};
      };
      format = " {:%I:%M}";
      tooltip = "true";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = " {:%d/%m}";
    };
    "custom/weather" = {
      format = "{}°";
      tooltip = true;
      interval = 3600;
      exec = "wttrbar --nerd --ampm --fahrenheit --mph";
      return-type = "json";
    };
    "hyprland/workspaces" = {
      active-only = false;
      disable-scroll = true;
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "1" = "Ⅰ";
        "2" = "Ⅱ";
        "3" = "Ⅲ";
        "4" = "Ⅳ";
        "5" = "Ⅴ";
        "6" = "Ⅵ";
        urgent = "";
        default = "";
        sort-by-number = true;
      };
      persistent-workspaces = {
        "1" = [];
        "2" = [];
        # "3"= [];
        # "4"= [];
        # "5"= [];
      };
    };
    memory = {
      format = "󰟜 {}%";
      format-alt = "󰟜 {used} GiB"; # 
      interval = 2;
    };
    cpu = {
      format = "  {usage}%";
      format-alt = "  {avg_frequency} GHz";
      interval = 2;
    };
    disk = {
      # path = "/";
      format = "󰋊 {percentage_used}%";
      interval = 60;
    };
    network = {
      format-wifi = "{icon} {signalStrength}%";
      format-ethernet = "󰀂 ";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "󰖪 ";
      format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
    };
    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = " {volume}%";
      # format-bluetooth = "{icon} {volume}% 󰂯";
      format-icons = {
        headphone = "󰋋";
        hands-free = "󱡒";
        headset = "󰋎";
        phone = "";
        portable = "";
        car = "";
        default = [" " " " " "];
      };
      scroll-step = 5;
      on-click = "pamixer -t";
      tooltip-format = "{time}";
    };
    battery = {
      format = "{icon} {capacity}%";
      format-icons = [" " " " " " " " " "];
      format-charging = " {capacity}%";
      format-full = " {capacity}%";
      format-warning = " {capacity}%";
      interval = 5;
      states = {
        warning = 20;
      };
      format-time = "{H}h{M}m";
      tooltip = true;
      tooltip-format = "{time}";
    };
    "custom/launcher" = {
      format = "";
      on-click = "fuzzel";
      on-click-right = "wallpaper-picker";
      tooltip = false;
    };
    "custom/notification" = {
      tooltip = false;
      format = "{icon}";
      format-icons = {
        notification = "<span foreground='red'><sup></sup></span>   ";
        none = "   ";
        dnd-notification = "<span foreground='red'><sup></sup></span>   ";
        dnd-none = "   ";
        inhibited-notification = "<span foreground='red'><sup></sup></span>   ";
        inhibited-none = "   ";
        dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>   ";
        dnd-inhibited-none = "   ";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "swaync-client -swb";
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };
  };
}

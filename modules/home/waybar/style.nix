{...}: let
  custom = {
    font = "JetBrainsMono Nerd Font";
    font_size = "15px";
    font_weight = "bold";
    text_color = "#cdd6f4";
    secondary_accent = "89b4fa";
    tertiary_accent = "f5f5f5";
    background = "11111B";
    opacity = "0.98";
  };
in {
  programs.waybar.style = ''
    @define-color rosewater #f5e0dc;
    @define-color flamingo #f2cdcd;
    @define-color pink #f5c2e7;
    @define-color mauve #cba6f7;
    @define-color red #f38ba8;
    @define-color maroon #eba0ac;
    @define-color peach #fab387;
    @define-color yellow #f9e2af;
    @define-color green #a6e3a1;
    @define-color teal #94e2d5;
    @define-color sky #89dceb;
    @define-color sapphire #74c7ec;
    @define-color blue #89b4fa;
    @define-color lavender #b4befe;
    @define-color text #cdd6f4;
    @define-color subtext1 #bac2de;
    @define-color subtext0 #a6adc8;
    @define-color overlay2 #9399b2;
    @define-color overlay1 #7f849c;
    @define-color overlay0 #6c7086;
    @define-color surface2 #585b70;
    @define-color surface1 #45475a;
    @define-color surface0 #313244;
    @define-color base #1e1e2e;
    @define-color mantle #181825;
    @define-color crust #11111b;

    * {
        border: none;
        border-radius: 0px;
        padding: 0;
        margin: 0;
        min-height: 0px;
        font-family: ${custom.font};
        font-weight: ${custom.font_weight};
        opacity: ${custom.opacity};
    }

    window#waybar {
        background-color: @base;
        color: @text;
    }

    #workspaces {
        font-size: 18px;
        padding-left: 15px;
    }
    #workspaces button {
        color: @text;
        padding-left:  6px;
        padding-right: 6px;
    }
    #workspaces button:hover {
        color: @mauve;
    }
    #workspaces button.focused {
        color: @mauve;
    }
    #workspaces button.empty {
        color: @overlay0;
    }
    #workspaces button.active {
        color: @lavender;
    }
    #workspaces button.urgent {
        color: @red;
    }

    #tray, #pulseaudio, #network, #cpu, #memory, #disk, #clock, #battery, #custom-notification, #custom-weather, #idle_inhibitor {
        font-size: ${custom.font_size};
        color: @text;
    }

    #cpu {
        padding-left: 15px;
        padding-right: 9px;
        margin-left: 7px;
        color: @red;
    }
    #memory {
        padding-left: 9px;
        padding-right: 9px;
        color: @yellow;
    }
    #disk {
        padding-left: 9px;
        padding-right: 15px;
        color: @pink;
    }

    #tray {
        padding: 0 20px;
        margin-left: 7px;
    }

    #pulseaudio {
        padding-left: 15px;
        padding-right: 9px;
        margin-left: 7px;
        color: @peach;
    }
    #pulseaudio.muted {
        color: @overlay0;
    }
    #battery {
        padding-left: 9px;
        padding-right: 9px;
        color: @green;
    }
    #battery.warning {
        color: @red;
    }
    #battery.charging {
        color: @teal;
    }
    #network {
        padding-left: 9px;
        padding-right: 30px;
        color: @blue;
    }
    #network.disconnected {
        color: @overlay0;
    }

    #custom-notification {
        padding-left: 20px;
        padding-right: 20px;
        color: @flamingo;
    }

    #clock {
        padding-left: 9px;
        padding-right: 15px;
        color: @mauve;
    }
    #clock.date {
        color: @lavender;
    }

    #idle_inhibitor {
        color: @yellow;
    }
    #idle_inhibitor.activated {
        color: @red;
    }

    #custom-weather {
        color: @sky;
    }

    #custom-launcher {
        font-size: 20px;
        color: @lavender;
        font-weight: ${custom.font_weight};
        padding-left: 10px;
        padding-right: 15px;
    }

    #temperature { color: @peach; }
    #backlight { color: @yellow; }
  '';
}

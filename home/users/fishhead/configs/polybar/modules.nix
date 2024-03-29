{ config, pkgs, lib, ... }:

{
  "module/xkeyboard" = {
    type = "internal/xkeyboard";
    blacklist-0 = "num lock";

    format = "<label-layout> <label-indicator>";
    format-underline = "\${colors.secondary-content}";
    label-layout = "%layout%";
    # format-prefix =  "🖮 ";
    format-background = "\${colors.background-highlight}";
    format-foreground = "\${colors.yellow}";
  };

  "module/filesystem" = {
    type = "internal/fs";

    mount-0 = "/";
    # mount-1 = "/home";
    format-background = "\${colors.background-highlight}";
    format-foreground = "\${colors.green}"; 

    fixed-values = true;
    spacing = 1;
    format-mounted = "<label-mounted>";
  };

  "module/distro-icon" = {
    type = "custom/script";
    exec =
      "${pkgs.coreutils}/bin/uname -r | ${pkgs.coreutils}/bin/cut -d- -f1";
    interval = 999999999;

    format = " <label>";
    format-background = "\${colors.background-highlight}";
    format-foreground = "\${colors.blue}";
    format-padding = 1;
    label = "%output%";
    label-font = 2;
  };

  "module/audio" = {
    type = "internal/alsa";

    format-volume = "墳 VOL <label-volume>";
    format-volume-padding = 1;
    format-volume-background = "\${colors.background-highlight}";
    format-volume-foreground = "\${colors.yellow}";
    label-volume = "%percentage%%";

    format-muted = "<label-muted>";
    format-muted-padding = 1;
    format-muted-background = "\${colors.yellow}";
    format-muted-foreground = "\${colors.background-highlight}";
    format-muted-prefix = "婢 ";
    format-muted-prefix-foreground = "\${colors.red}";
    format-muted-overline = "\${colors.background}";

    label-muted = "VOL Muted";
  };

  "module/battery" = {
    type = "internal/battery";
    full-at = 101; # to disable it
    battery = "BAT0"; # TODO: Better way to fill this
    adapter = "AC0";

    poll-interval = 2;

    label-full = " 100%";
    format-full-padding = 1;
    format-full-background = "\${colors.background-highlight}";
    format-full-foreground = "\${colors.yellow}";

    format-charging = " <animation-charging> <label-charging>";
    format-charging-padding = 1;
    format-charging-background = "\${colors.background-highlight}";
    format-charging-foreground = "\${colors.yellow}";
    label-charging = "%percentage%% +%consumption%W";
    animation-charging-0 = "";
    animation-charging-1 = "";
    animation-charging-2 = "";
    animation-charging-3 = "";
    animation-charging-4 = "";
    animation-charging-framerate = 500;

    format-discharging = "<ramp-capacity> <label-discharging>";
    format-discharging-padding = 1;
    format-discharging-background = "\${colors.background-highlight}";
    format-discharging-foreground = "\${colors.yellow}";
    label-discharging = "%percentage%% -%consumption%W";
    ramp-capacity-0 = "";
    ramp-capacity-0-foreground = "\${colors.red}";
    ramp-capacity-1 = "";
    ramp-capacity-1-foreground = "\${colors.red}";
    ramp-capacity-2 = "";
    ramp-capacity-3 = "";
    ramp-capacity-4 = "";
  };

  "module/cpu" = {
    type = "internal/cpu";

    interval = "0.5";

    format = " <label>";
    format-background = "\${colors.background-highlight}";
    format-foreground = "\${colors.magenta}";
    format-padding = 1;

    label = "CPU %percentage%%";
  };

  "module/memory" = {
    type = "internal/memory";

    interval = 3;

    format = " <label>";
    format-background = "\${colors.background-highlight}";
    format-foreground = "\${colors.violet}";
    format-padding = 1;

    label = "RAM %percentage_used%%";
  };

  "module/date" = {
    type = "internal/date";

    interval = "1.0";

    time = "%H:%M:%S";
    time-alt = "%Y-%m-%d%";

    format = "<label>";
    format-padding = 2;
    format-background = "\${colors.background-highlight}";
    format-foreground = "\${colors.yellow}";

    label = "%time%";
  };

  "module/i3" = {
    type = "internal/i3";
    pin-workspaces = false;
    strip-wsnumbers = true;
    format = "<label-state> <label-mode>";
    format-background = "\${colors.background-highlight}";

    ws-icon-0 = "1;";
    ws-icon-1 = "2;";
    ws-icon-2 = "3;﬏";
    ws-icon-3 = "4;";
    ws-icon-4 = "5;";
    ws-icon-5 = "6;";
    ws-icon-6 = "7;";
    ws-icon-7 = "8;";
    ws-icon-8 = "9;";
    ws-icon-9 = "10;";

    label-mode = "%mode%";
    label-mode-padding = 1;

    label-unfocused = "%icon%";
    label-unfocused-foreground = "\${colors.secondary-content}";
    label-unfocused-padding = 1;

    label-focused = "%index% %icon%";
    label-focused-font = 2;
    label-focused-foreground = "\${colors.cyan}";
    label-focused-padding = 1;

    label-visible = "%icon%";
    label-visible-padding = 1;

    label-urgent = "%index%";
    label-urgent-foreground = "\${colors.red}";
    label-urgent-padding = 1;

    label-separator = "";
  };

  "module/title" = {
    type = "internal/xwindow";
    format = "<label>";
    label = "%title%";
    label-maxlen = 70;
  };

  "module/wireless-network" = {
    type = "internal/network";
    interface = "wlp0s20f3";
    interval = "3.0";
    format-connected-background = "\${colors.background-highlight}";
    format-connected-foreground = "\${colors.orange}";
    format-disconnected-background = "\${colors.background-highlight}";
    format-disconnected-backgroforegroundund = "\${colors.orange}";
  };

  "module/network" = {
    type = "internal/network";
    interface = "eno2";

    interval = "1.0";

    accumulate-stats = true;
    unknown-as-up = true;

    format-connected = "<label-connected>";
    format-connected-background = "\${colors.background-highlight}";
    format-connected-foreground = "\${colors.orange}";

    format-disconnected = "<label-disconnected>";
    format-disconnected-background = "\${colors.background-highlight}";
    format-disconnected-backgroforegroundund = "\${colors.orange}";

    label-connected = "D %downspeed:2% | U %upspeed:2%";
    label-disconnected = "DISCONNECTED";
  };

  # "module/temperature" = {
  #   type = "internal/temperature";

  #   interval = "0.5";

  #   thermal-zone = 0; # TODO: Find a better way to fill that
  #   warn-temperature = 60;
  #   units = true;

  #   format = "<label>";
  #   format-background = mf;
  #   format-underline = bg;
  #   format-overline = bg;
  #   format-padding = 2;
  #   format-margin = 0;

  #   format-warn = "<label-warn>";
  #   format-warn-background = mf;
  #   format-warn-underline = bg;
  #   format-warn-overline = bg;
  #   format-warn-padding = 2;
  #   format-warn-margin = 0;

  #   label = "TEMP %temperature-c%";
  #   label-warn = "TEMP %temperature-c%";
  #   label-warn-foreground = "#f00";
  # };

  "module/powermenu" = {
    type = "custom/menu";
    expand-right = true;

    format = "<label-toggle> <menu>";
    format-background = "\${colors.background}";
    format-padding = 1;

    label-open = "";
    label-close = "";
    label-separator = "  ";

    menu-0-0 = " Suspend";
    menu-0-0-exec = "systemctl suspend";
    menu-0-1 = " Reboot";
    menu-0-1-exec = "v";
    menu-0-2 = " Shutdown";
    menu-0-2-exec = "systemctl poweroff";
  };
}

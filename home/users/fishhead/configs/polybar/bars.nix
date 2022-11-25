{ config, pkgs, lib, ... }:

{
  "bar/top" = {
    monitor-strict = true;
    dpi = "[0-9]+";
    bottom = false;
    width = "100%";
    height = 30;

    # scroll-up = "i3wm-wsnext";
    # scroll-down = "i3wm-wsprev";

    background = "\${colors.background}";
    foreground = "\${colors.foreground}";

    underline-size = 2;
    underline-color = "#00f";

    module-margin-right = 1;
    modules-left = "i3";
    modules-right = "audio date";

    tray-position = "right";
    tray-padding = 3;
    tray-detached = false;
    tray-maxsize = 16;
    tray-background = "\${colors.background-highlight}";
    enable-ipc = false;

    wm-stack = "i3";
    override-redirect = false;

    font-0 = "FuraMono Nerd Font:size=12;3";
    font-1 = "FuraMono Nerd Font:style=Bold:size=12;3";

    locale = "en_US.UTF-8";
  };

  "bar/bottom" = {
    bottom = true;
    fixed-center = true;

    width = "100%";
    height = 25;

    module-margin-right = 1;

    background = "\${colors.background}";
    foreground = "\${colors.foreground}";

    modules-left = "network wireless-network";
    # modules-center = "time-tomsk";
    modules-right = "xkeyboard filesystem cpu memory battery powermenu";

    font-0 = "FuraMono Nerd Font:size=12;3";
    font-1 = "FuraMono Nerd Font:style=Bold:size=12;3";

    locale = "en_US.UTF-8";
  };
}
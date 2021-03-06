{pkgs, config, lib, ...}:
with lib;
with builtins;
let
  xorg = (elem "xorg" config.sys.graphics.desktopProtocols);
  desktopMode = xorg;
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];
  config = mkIf desktopMode {
    home-manager.users.fishhead.xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraConfig = "popup_during_fullscreen smart\ndefault_border pixel 1\ndefault_floating_border pixel 1\n";

      config = rec {
        modifier = "Mod4";
        bars = [ ];

        focus.forceWrapping = true;
        floating.modifier = "Mod4";

        workspaceAutoBackAndForth = true;
        workspaceLayout = "tabbed";

        colors = {
          focused =         { background = "#839496"; border = "#839496"; childBorder = "#5f676a"; indicator = "#002B36"; text = "#002B36"; };
          unfocused =       { background = "#00252E"; border = "#00252E"; childBorder = "#5f676a"; indicator = "#839496"; text = "#839496"; };
          focusedInactive = { background = "#00252E"; border = "#00252E"; childBorder = "#5f676a"; indicator = "#00252E"; text = "#839496"; };
          urgent =          { background = "#E59847"; border = "#E59847"; childBorder = "#5f676a"; indicator = "#839496"; text = "#00252E"; };
        };

        fonts = {
          names = [ "FuraCode Nerd Font" ];
          size = 10.0;
        };

        window = {
          border = 1;
          hideEdgeBorders = "smart";
          # titlebar = false;
          commands = [ 
            # { command = "border pixel 1"; criteria = { class = "^.*"; }; } 
            { command = "floating enable"; criteria = { window_role = "pop-up"; }; } 
            { command = "floating enable"; criteria = { window_role = "task_dialog"; }; } 
            { command = "floating enable"; criteria = { class = "qt5ct|Lxappearance|^Gpick$|Pamac|Peek|Nitrogen|Audacious|Pavucontrol"; }; } 
            { command = "focus"; criteria = { class = "Gksu|Pinentry|Pinentry-gtk-2|pinentry-gnome3"; }; } 
            { command = "no_focus"; criteria = { class = "Skype"; }; }
            { command = "layout tabbed"; criteria = { class = "^URxvt$"; instance = "^weechat$"; }; }
            { command = "move to workspace 5, workspace --no-auto-back-and-forth 5"; criteria = { class = "Spotify"; }; }
          ];
        };

        assigns = {
          "1" = [{ class = "^alacritty$"; }];
          "2" = [{ instance = "^Navigator$"; class = "^Firefox$"; }];
          "3" = [{ class = "^Code$"; }];
          "4" = [{ class = "^TelegramDesktop$|^Skype$|^Slack$|^zoom$"; }];
          "5" = [{ class = "^VirtualBox$|^TeamViewer$"; }];
          "0" = [{ class = "^Doublecmd$"; window_role = "About"; }];
        };

        # gaps = {
        #   inner = 15;
        #   outer = 5;
        # };

        keybindings = lib.mkOptionDefault {
          "XF86AudioMute" = "exec amixer set Master toggle";
          "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
          "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";
          "XF86MonBrightnessDown" = "exec brightnessctl set 4%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set 4%+";
          "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun -show-icons";
          "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -modi window -show window -show-icons";
          "${modifier}+Shift+x" = "exec systemctl suspend";
          ##### new
          # Lock the computer
          "${modifier}+l" = "exec i3lock-pixeled";
          # Start rofi
          "F10" = "exec ${pkgs.rofi}/bin/rofi -modi filebrowser -show filebrowser -show-icons";
          "F11" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";
          "F12" = "exec ${pkgs.rofi-systemd}/bin/rofi-systemd";
          # rofi_power menu
          "${modifier}+Shift+e" = "exec sh $HOME/.config/i3/rofi_powermenu.sh";
          # rofi_custom menu
          "${modifier}+x" = "exec sh $HOME/.config/i3/rofi_custom.sh";
          # launch polybar
          "${modifier}+ctrl+c" = "exec sh $HOME/.config/i3/polybar.sh";
          # Google search 
          "${modifier}+Shift+s" = "exec ${pkgs.rofi}/bin/rofi -dmenu -p \"Search\" | xargs -I{} xdg-open https://www.google.com/search?q={}";
          # for merge into new window
          "${modifier}+M" = "focus left;split v;layout stacking;focus right;move left";
          "${modifier}+comma" = "focus right;split v;layout stacking;focus left;move right";
        };

        # workspaceOutputAssign = [
        #   { workspace = "workspace 1"; output = "eDP-1"; }
        #   { workspace = "2"; output = "eDP-1"; }
        #   { workspace = "3"; output = "eDP-1"; }
        #   { workspace = "4"; output = "eDP-1"; }
        #   { workspace = "5"; output = "HDMI-1"; }
        #   { workspace = "6"; output = "HDMI-1"; }
        #   { workspace = "7"; output = "HDMI-1"; }
        #   { workspace = "8"; output = "HDMI-1"; }
        #   { workspace = "9"; output = "HDMI-1"; }
        #   { workspace = "10"; output = "HDMI-1"; }
        # ];

        startup = [
          {
            command = "$HOME/.nix-profile/bin/alacritty -e tmux";
            always = false;
            notification = false;
          }
          {
            command = "setxkbmap -option \"grp:caps_toggle,grp_led:caps\" -layout \"us,ru\"";
            always = false;
            notification = false;
          }
          {
            command = "exec i3-msg workspace 1";
            always = true;
            notification = false;
          }
          {
            command = "systemctl --user restart polybar.service";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.feh}/bin/feh --bg-scale ~/background.jpg";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.rescuetime}/bin/rescuetime";
            always = false;
            notification = false;
          }
          {
            # Launch sound tray icon
            command = "${pkgs.pasystray}/bin/pasystray";
            always = false;
            notification = false;
          }
          {
            # network-monior
            command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
            always = false;
            notification = false;
          }
          {
            # Firefox
            command = "firefox";
            always = false;
            notification = false;
          }
          {
            # VScode
            command = "code";
            always = false;
            notification = false;
          }
          {
            # Slack
            command = "slack";
            always = false;
            notification = false;
          }
          {
            # Telegram
            command = "telegram-desktop";
            always = false;
            notification = false;
          }
          {
            # Spotify
            command = "spotify";
            always = false;
            notification = false;
          }
        ];
      };
    };

    # home.files = {
    #   rofi_powermenu = {
    #     path = ".config/i3/rofi_powermenu.sh";
    #     text = ''
    #       #!/bin/bash
    #       action=$(echo -e "lock\nlogout\nshutdown\nreboot" | rofi -dmenu -p "power:")

    #       if [[ "$action" == "lock" ]]
    #       then
    #           ~/.i3/i3lock-fancy-multimonitor/lock
    #       fi

    #       if [[ "$action" == "logout" ]]
    #       then
    #           i3-msg exit
    #       fi

    #       if [[ "$action" == "shutdown" ]]
    #       then
    #           systemctl poweroff
    #       fi

    #       if [[ "$action" == "reboot" ]]
    #       then
    #           shutdown -r now
    #       fi 
    #     '';
    #   };

    #   rofi_custom = {
    #     path = ".config/i3/rofi_custom.sh";
    #     text = ''
    #       #!/bin/bash
    #       action=$(echo -e "ompd\nompd-git\nspotify\ntransmission\nnicotine\nstreamstudio\nnetflix\nmps-youtube" | rofi -dmenu -p "custom:")

    #       if [[ "$action" == "ompd" ]]
    #       then
    #           /usr/bin/google-chrome-stable --app="http://127.0.0.1/OMPD"
    #       fi

    #       if [[ "$action" == "ompd-git" ]]
    #       then
    #           /usr/bin/google-chrome-stable --app="http://127.0.0.1/ompd_test"
    #       fi

    #       if [[ "$action" == "transmission" ]]
    #       then
    #           /usr/bin/google-chrome-stable --app="http://localhost:9091/transmission/web/"
    #       fi

    #       if [[ "$action" == "streamstudio" ]]
    #       then
    #           streamstudio
    #       fi

    #       if [[ "$action" == "netflix" ]]
    #       then
    #           /usr/bin/google-chrome-stable --app="https://www.netflix.com"
    #       fi

    #       if [[ "$action" == "mps-youtube" ]]
    #       then
    #           urxvtc -e mpsyt
    #       fi

    #       if [[ "$action" == "nicotine" ]]
    #       then
    #           nicotine
    #       fi

    #       if [[ "$action" == "spotify" ]]
    #       then
    #           blockify
    #       fi 
    #     '';
    #   };

    #   polybar = {
    #     path = ".config/i3/polybar.sh";
    #     text = ''
    #       #!/usr/bin/env sh
    #       # Terminate already running bar instances
    #       killall -q polybar

    #       # Wait until the processes have been shut down
    #       while pgrep -x polybar >/dev/null; do sleep 1; done

    #       for m in $(polybar --list-monitors | cut -d":" -f1); do
    #           export TRAY_POSITION=none
    #           if [[ $m == "eDP1" ]]; then
    #               TRAY_POSITION=right
    #           fi
    #           MONITOR=$m polybar --reload powerbar &
    #       done 
    #     '';
    #   };
    # };
  };
}

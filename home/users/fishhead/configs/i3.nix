{ pkgs, lib, config, systemConfig ? (import <nixpkgs/nixos> {}).config, ... }:
let
  hostname = "${builtins.readFile /etc/hostname }";
in
{
  home.file.".xprofile".source = ./i3/xprofile;
  home.file.".config/i3/rofi_powermenu.sh".source = ./i3/rofi_powermenu.sh;
  home.file.".config/i3/rofi_custom.sh".source = ./i3/rofi_custom.sh;
  home.file.".config/i3/polybar.sh".source = ./polybar/launch.sh;
  
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;
    extraConfig = "popup_during_fullscreen smart\ndefault_border pixel 1\ndefault_floating_border pixel 1\n";

    config = rec {
      # modifier = if systemConfig.networking.hostName != "lenovo" then "Mod4" else "Mod1";
      modifier = if hostname != "lenovo" then "Mod4" else "Mod1";
      # modifier = "Mod1";
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
          { command = "move to workspace 5, workspace --no-auto-back-and-forth 5"; criteria = { class = "spotify"; }; }
        ];
      };

      assigns = {
        "1" = [{ class = "^alacritty$"; }];
        "2" = [{ instance = "^Navigator$"; class = "^Firefox$"; }];
        "3" = [{ class = "^Code$"; }];
        "4" = [{ class = "^TelegramDesktop$|^Skype$|^Slack$|^zoom$"; }];
        "5" = [{ class = "^VirtualBox$|^TeamViewer$|^Spotify$"; }];
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
          command = "$HOME/.nix-profile/bin/alacritty";
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
}

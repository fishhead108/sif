{ lib, config, inputs, pkgs, ...}:
let
start-portal = pkgs.writeScript "start-portal" ''
  #!/bin/bash
  sleep 1
  killall -e xdg-desktop-portal-hyprland
  killall -e xdg-desktop-portal-wlr
  killall xdg-desktop-portal
  /usr/lib/xdg-desktop-portal-hyprland &
  sleep 2
  /usr/lib/xdg-desktop-portal &
'';

rofi_exitmenu = "sh " + pkgs.writeScript "rofi_exitmenu" ''
  #!${pkgs.stdenv.shell} --login

  action=$(echo -e "lock\nlogout\nshutdown\nreboot" | wofi --dmenu -p "power:")

  if [[ "$action" == "lock" ]]
  then
      ~/.i3/i3lock-fancy-multimonitor/lock
  fi

  if [[ "$action" == "logout" ]]
  then
    HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
    hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1
    hyprctl dispatch exit
  fi

  if [[ "$action" == "shutdown" ]]
  then
    HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
    hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1
    systemctl poweroff
  fi

  if [[ "$action" == "reboot" ]]
  then
    HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
    hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1
    shutdown -r now
  fi
'';

in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
    extraConfig = ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=DP-2, 2560x1440@59, 0x0, 1
      monitor=HDMI-3, 2560x1440@59, 2560x0, 1

      # Source a file (multi-file configs)
      # source = /home/josiah/.config/hypr/mocha.conf

      # Execute your favorite apps at launch
      exec-once = swww init
      exec = sleep 0.5 && default_wallpaper

      exec-once = dunst
      exec-once = nm-applet --indicator
      exec = pkill waybar & sleep 0.5 && waybar

      exec-once = ${start-portal}
      exec-once = alacritty -e tmux
      exec-once = rescuetime
      exec-once = LIBVA_DRIVER_NAME=iHD firefox
      exec-once = code
      exec-once = obsidian
      exec-once = LIBVA_DRIVER_NAME=iHD slack
      exec-once = telegram-desktop
      exec-once = thunderbird
      exec-once = flatpak run com.spotify.Client
      exec-once = LIBVA_DRIVER_NAME=iHD google-chrome-stable --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization, --disable-gpu-driver-bug-workarounds --disable-features=UseSkiaRenderer,UseChromeOSDirectVideoDecoder --canvas-oop-rasterization --use-vulkan --disable-software-rasterizer

      # Some default env vars.
      env = XCURSOR_SIZE,24

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
        kb_layout = us,ru
        kb_variant =
        kb_model =
        kb_options = grp:caps_toggle
        kb_rules =

        follow_mouse = 1
        float_switch_override_focus = 2

        touchpad {
            natural_scroll = no
        }

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 3
        gaps_out = 5
        border_size = 1
        #   col.active_border = rgb($mauveAlpha) rgb($blueAlpha) 45deg
        #   col.inactive_border = rgb($baseAlpha)
        resize_on_border = yes
        extend_border_grab_area = 15
        layout = dwindle
      }

      decoration {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
          rounding = 10
          blur {
            enabled = true
            size = 3 
            new_optimizations = true
            passes = 1
          }

          drop_shadow = yes
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          enabled = yes

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default, fade
      }

      dwindle {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = yes 
          preserve_split = yes 
      }

      master {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true
      }

      gestures {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = off
      }

      device:epic-mouse-v1 {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
          sensitivity = -0.5
      }

      binds {
        allow_workspace_cycles = true
        workspace_back_and_forth = true
      }

      group {
        insert_after_current = true
      }

      # Example windowrule v1
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # windowrule = float, ^(kitty)$
      windowrule = float,^(pavucontrol)$
      windowrule = float,^(blueman-manager)$
      windowrule = float,^(nm-connection-editor)$
      windowrule = float,^(chromium)$
      windowrule = float,^(thunar)$
      windowrule = float, title:^(btop)$
      windowrule = float, title:^(update-sys)$
      windowrule = maximize, class:^(firefox)$

      # Place apps per workspace
      windowrule = workspace 1, ^(.*Alacritty.*)$
      windowrule = workspace 1, ^(.*Kitty.*)$
      windowrule = workspace 1, ^(.*Termite.*)$
      windowrule = workspace 2, ^(.*firefox.*)$
      windowrule = monitor=DP-2, ^(.*firefox.*)$
      windowrule = workspace 3, ^Code$
      windowrule = workspace 3, ^(.*obsidian.*)$
      windowrule = workspace 4, ^org.telegram.desktop$|^Skype$|^Slack$|^zoom$|^thunderbird$
      windowrule = workspace 5, ^spotify$|^Spotify$|^VirtualBox$|^TeamViewer$
      windowrule = workspace 6, ^(.*Google-chrome.*)$
      windowrule = monitor HDMI-3, ^(.*Google-chrome.*)$

      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # windowrule = opacity 0.9 0.7, ^(kitty)$
      # windowrule = opacity 0.95 0.8, ^(obsidian)$
      windowrulev2 = opacity 0.8 0.8,class:^(alacritty)$
      windowrulev2 = animation popin,class:^(alacritty)$,title:^(update-sys)$
      windowrulev2 = animation popin,class:^(thunar)$
      windowrulev2 = opacity 0.8 0.8,class:^(thunar)$
      windowrulev2 = opacity 0.8 0.8,class:^(VSCodium)$
      windowrulev2 = animation popin,class:^(chromium)$
      windowrulev2 = maximize,class:^(Google-chrome)$
      windowrulev2 = maximize,class:^(.*Slack.*)$
      windowrulev2 = maximize,class:^(.*org.telegram.desktop.*)$
      windowrulev2 = maximize,class:^(.*obsidian.*)$
      windowrulev2 = maximize,class:^(.*thunderbird.*)$
      windowrulev2 = move cursor -3% -105%,class:^(wofi)$
      windowrulev2 = noanim,class:^(wofi)$
      windowrulev2 = opacity 0.8 0.6,class:^(wofi)$
      windowrulev2 = float,class:^(thunderbird)$,title:^(.*)(Reminder)(.*)$
      # windowrulev2 = float, class:^(org.keepassxc.KeePassXC)$, title:^(KeePassXC -  Access Request)$
      # windowrulev2 = center, class:^(org.keepassxc.KeePassXC)$, title:^(KeePassXC -  Access Request)$

      # Screen sharing
      windowrulev2 = opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$
      windowrulev2 = noanim,class:^(xwaylandvideobridge)$
      windowrulev2 = nofocus,class:^(xwaylandvideobridge)$
      windowrulev2 = noinitialfocus,class:^(xwaylandvideobridge)$

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = ALT

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, Return, exec, alacritty
      bind = $mainMod, F4, killactive, 
      # bind = $mainMod, M, exit, 
      # bind = $mainMod, V, togglefloating, 
      bind = $mainMod, R, exec, sh $HOME/.config/rofi/bin/launcher
      bind = $mainMod, S, exec, grim -g "$(slurp)" - | swappy -f -
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle
      bind = $mainMod, L, exec, swaylock # Lock the screen
      bind = $mainMod, M, exec, wlogout --protocol layer-shell # show the logout window
      bind = $mainMod SHIFT, M, exit, # Exit Hyprland all together no (force quit Hyprland)
      bind = $mainMod, E, exec, thunar # Show the graphical file browser
      bind = $mainMod, V, togglefloating, # Allow a window to float
      bind = $mainMod SHIFT, E, exec, ${rofi_exitmenu}
      bind = $mainMod, D, exec, wofi --show drun --allow-images # Show the graphical app launcher
      bind = $mainMod, S, exec, grim -g "$(slurp)" - | swappy -f - # take a screenshot
      bind = ALT, V, exec, cliphist list | wofi -dmenu | cliphist decode | wl-copy # open clipboard manager
      # bind = $mainMod, T, exec, ~/.config/HyprV/hyprv_util vswitch # switch HyprV version

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
    '';
  };
}
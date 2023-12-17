{ config, lib, pkgs, ...}:
let
btm = "${pkgs.bottom}/bin/btm";
jq  = "${pkgs.jq}/bin/jq";
gsimplecal = "${pkgs.gsimplecal}/bin/gsimplecal";
wofi = "${pkgs.wofi}/bin/wofi";
terminal = "${pkgs.kitty}/bin/kitty";
terminal-spawn = cmd: "${terminal} $SHELL -i -c ${cmd}";
pctl = "${pkgs.playerctl}/bin/playerctl";

systemMonitor = terminal-spawn btm;

monitorScript   = pkgs.callPackage ./scripts/monitor.nix {};
mprisScript     = pkgs.callPackage ./scripts/mpris.nix {};
networkScript   = pkgs.callPackage ./scripts/network.nix {};

jsonOutput = name: { pre ? "", text ? "", tooltip ? "", alt ? "", class ? "", percentage ? "" }: "${pkgs.writeShellScriptBin "waybar-${name}" ''
    set -euo pipefail
    ${pre}
    ${jq} -cn \
      --arg text "${text}" \
      --arg tooltip "${tooltip}" \
      --arg alt "${alt}" \
      --arg class "${class}" \
      --arg percentage "${percentage}" \
      '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
  ''}/bin/waybar-${name}";

in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true"] ;} );
    
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };

    settings = {
      mainBar = {
        layer = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "custom/mpris" "clock" ];
        modules-right = [ "hyprland/language" "cpu" "memory" "pulseaudio" "bluetooth" "network" "tray" ];

        "custom/nix" = {
          "format" = "   ";
          "tooltip" = false;
          # "on-click" = "sh $HOME/.config/i3/rofi_powermenu.sh";
          "on-click" = "sh " + pkgs.writeScript "rofi_powermenu" ''
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
        };

        # "custom/menu" = {
        #   return-type = "json";
        #   exec = jsonOutput "menu" {
        #     text = "";
        #     tooltip = ''$(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f2)'';
        #   };
        #   on-click = "${wofi} -S drun -x 10 -y 10 -W 25% -H 60%";
        # };

        "custom/mpris" = {
          exec = "echo $(${pctl} --player=spotify,%any metadata --format '{{ artist }} - {{ title }}')";
          interval = 5;
          format = "<span color='#b4befe'> {}</span>";
        };

        "tray" = {
          "icon-size" = 18;
          "spacing" = 10;
        };

        "hyprland/language" = {
          "format" = "<span color='#b4befe'>Lang: {}</span>";
          "format-en" = "us";
          "format-ru" = "ru";
          "keyboard-name" = "kinesis-advantage2-keyboard-1";
        };

        # "keyboard-state": {
        # "numlock": true,
        # "capslock": true,
        # "format": " {name} {icon}",
        # "format-icons": {
        #   "locked": "",
        #   "unlocked": ""
        #   }
        # },

        "privacy" =  {
          "icon-spacing" = 4;
          "icon-size" = 18;
          "transition-duration" = 250;
          "modules" = [
            {
              "type" = "screenshare";
              "tooltip" = true;
              "tooltip-icon-size" = 24;
            }
            {
              "type" = "audio-out";
              "tooltip" = true;
              "tooltip-icon-size" = 24;
            }
            {
              "type" = "audio-in";
              "tooltip" = true;
              "tooltip-icon-size" = 24;
            }
          ];
        };
        
        "hyprland/workspaces" = {
          "format" = "<span color='#b4befe'>{icon}</span>";
          # "active-only" = true;
          "all-outputs" = false;
          "format-icons" = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "九";
            "10" = "十";
          };
        };

        "hyprland/window" =  {
          "format" =  "👉 {}";
          "rewrite" =  {
            "(.*) — Mozilla Firefox" =  "🌎 $1";
            "(.*) - fish" =  "> [$1]";
          };
          "separate-outputs" =  true;
        };

        # "clock" = {
        #   "format" = "<span color='#b4befe'> </span>{:%H:%M:%S}";
        #   "interval" = 1;
        #   "tooltip" = true;
        #   "tooltip-format" = "{:%Y-%m-%d %a}";
        #   on-click = gsimplecal;
        #   "on-click-middle" = "exec default_wallpaper";
        #   "on-click-right" = "exec wallpaper_random";
        # };

        "clock" = {
          "format" = "<span color='#b4befe'> </span>{:%H:%M:%S}";
          "interval" = 1;
          # "format-alt" = "{:%A, %B %d, %Y (%R)}  ";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
            "mode"           = "year";
            "mode-mon-col"   = 3;
            "weeks-pos"      = "right";
            "on-scroll"      = 1;
            "on-click-right" = "mode";
            "format" = {
              "months" =     "<span color='#ffead3'><b>{}</b></span>";
              "days" =       "<span color='#ecc6d9'><b>{}</b></span>";
              "weeks" =      "<span color='#99ffdd'><b>{}</b></span>";
              "weekdays" =   "<span color='#ffcc66'><b>{}</b></span>";
              "today" =      "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          "actions" =  {
            "on-click-right" = "mode";
            "on-click-forward" = "tz_up";
            "on-click-backward" = "tz_down";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };

        "cpu" = { 
          "format" = "<span color='#b4befe'> </span>{usage}%"; 
          on-click = systemMonitor;
        };

        "memory" = {
          "interval" = 1;
          "format" = "<span color='#b4befe'> </span>{used:0.1f}G/{total:0.1f}G";
          on-click = systemMonitor;
        };

        "backlight" = {
          "device" = "intel_backlight";
          "format" = "<span color='#b4befe'>{icon}</span> {percent}%";
          "format-icons" = ["" "" "" "" "" "" "" "" ""];
        };

        "pulseaudio"= {
          "format" = "<span color='#b4befe'>{icon}</span> {volume}%";
          "format-muted" = "   0%";
          "tooltip" = false;
          "format-icons" = {
            "headphone" = "";
            "headset" = "";
            "default" = ["" "" "󰕾" "󰕾" "󰕾" "" "" ""];
          };
          "scroll-step" = 1;
          "on-click" = "pavucontrol";
        };

        "bluetooth" = {
          "format" = "<span color='#b4befe'></span> {status}";
          "format-disabled" = "";
          "format-connected" = "<span color='#b4befe'></span> {num_connections}";
          "tooltip-format" = "{device_enumerate}";
          "tooltip-format-enumerate-connected" = "{device_alias}   {device_address}";
        };

        "network" = {
          "interface" = "wlp3s0";
          "format" = "{ifname}";
          "format-wifi" = "<span color='#b4befe'> </span>{essid}";
          "format-ethernet" = "{ipaddr}/{cidr} ";
          "format-disconnected" = "<span color='#b4befe'>󰖪 </span>No Network";
          "tooltip" = false;
        };
        
        "battery" = {
          "format" = "<span color='#b4befe'>{icon}</span> {capacity}%";
          "format-icons" =  ["" "" "" "" "" "" "" "" "" ""];
          "format-charging" = "<span color='#b4befe'></span> {capacity}%";
          "tooltip" = false;
        };

      };
    };

    style = ''
      * {
        border: none;
        font-family: 'Fira Code', 'Symbols Nerd Font Mono';
        font-size: 16px;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
        min-height: 35px;
      }

      window#waybar {
        background: transparent;
      }

      #custom-mpris,
      #window,
      #workspaces {
        border-radius: 10px;
        background-color: #11111b;
        color: #b4befe;
        margin-top: 5px;
        margin-right: 15px;
        padding-top: 1px;
        padding-left: 10px;
        padding-right: 10px;
      }

      #custom-nix {
        font-size: 20px;
        margin-left: 15px;
        color: #b4befe;
      }

      #workspaces button.active {
        background: #7575bd;
        color: #cf4206;
      }

      #window, #privacy, #language, #clock, #pulseaudio, #bluetooth, #network, #cpu, #memory, #tray{
        border-radius: 10px;
        background-color: #11111b;
        color: #cdd6f4;
        margin-top: 5px;
        padding-left: 10px;
        padding-right: 10px;
        margin-right: 15px;
      }

      #backlight, #bluetooth {
        border-top-right-radius: 0;
        border-bottom-right-radius: 0;
        padding-right: 5px;
        margin-right: 0
      }

      #pulseaudio, #network {
        border-top-left-radius: 0;
        border-bottom-left-radius: 0;
        padding-left: 5px;
      }

      #clock {
        margin-right: 0;
      }
  '';
  };
}
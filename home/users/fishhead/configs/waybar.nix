{ config, lib, pkgs, ... }:

let
  inherit (pkgs.lib) optionals optional;

  # Dependencies
  jq = "${pkgs.jq}/bin/jq";
  xml = "${pkgs.xmlstarlet}/bin/xml";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  journalctl = "${pkgs.systemd}/bin/journalctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  playerctld = "${pkgs.playerctl}/bin/playerctld";
  neomutt = "${pkgs.neomutt}/bin/neomutt";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  btm = "${pkgs.bottom}/bin/btm";
  wofi = "${pkgs.wofi}/bin/wofi";
  # ikhal = "${pkgs.khal}/bin/ikhal";

  terminal = "${pkgs.kitty}/bin/kitty";
  terminal-spawn = cmd: "${terminal} $SHELL -i -c ${cmd}";

  # calendar = terminal-spawn ikhal;
  systemMonitor = terminal-spawn btm;
  mail = terminal-spawn neomutt;

  # Function to simplify making waybar outputs
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
    settings = {

      # secondary = {
      #   mode = "dock";
      #   layer = "top";
      #   height = 32;
      #   width = 100;
      #   margin = "6";
      #   position = "bottom";
      #   modules-center =  [
      #     "wlr/workspaces"
      #   ];

      #   "wlr/workspaces" = {
      #     on-click = "activate";
      #   };
      # };

      primary = {
        mode = "dock";
        layer = "bottom";
        height = 40;
        margin = "6";
        position = "top";
        modules-left = [
          "custom/menu"
          "idle_inhibitor"
          "custom/currentplayer"
          "custom/player"
        ];
        modules-center = [
          "cpu"
          "memory"
          "clock"
          "pulseaudio"
          "custom/gammastep"
          "custom/gpg-agent"
        ];
        modules-right = [
          "network"
          "custom/tailscale-ping"
          "battery"
          "tray"
          "custom/hostname"
        ];

        clock = {
          format = "{:%d/%m %H:%M}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          # on-click = calendar;
        };
        cpu = {
          format = "   {usage}%";
          on-click = systemMonitor;
        };
        memory = {
          format = "  {}%";
          interval = 5;
          on-click = systemMonitor;
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "   0%";
          format-icons = {
            headphone = "";
            headset = "";
            portable = "";
            default = [ "" "" "" ];
          };
          on-click = pavucontrol;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "零";
            deactivated = "鈴";
          };
        };
        battery = {
          bat = "BAT0";
          interval = 10;
          format-icons = [ "" "" "" "" "" "" "" "" "" "" ];
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          onclick = "";
        };
        "sway/window" = {
          max-length = 20;
        };
        network = {
          interval = 3;
          format-wifi = "   {essid}";
          format-ethernet = " Connected";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = "";
        };
        "custom/tailscale-ping" = {
          interval = 2;
          return-type = "json";
          exec =
            let
              targets = {
                electra = { host = "electra"; icon = " "; };
                merope = { host = "merope"; icon = " "; };
                atlas = { host = "atlas"; icon = " "; };
                maia = { host = "maia"; icon = " "; };
                pleione = { host = "pleione"; icon = " "; };
              };

              showPingCompact = { host, icon }: "${icon} $ping_${host}";
              showPingLarge = { host, icon }: "${icon} ${host}: $ping_${host}";
              setPing = { host, ... }: ''
                ping_${host}="$(timeout 2 ping -c 1 -q ${host} 2>/dev/null | tail -1 | cut -d '/' -f5 | cut -d '.' -f1)ms" || ping_${host}="Disconnected"
              '';
            in
            jsonOutput "tailscale-ping" {
              pre = ''
                set -o pipefail
                ${builtins.concatStringsSep "\n" (map setPing (builtins.attrValues targets))}
              '';
              text = "${showPingCompact targets.electra} / ${showPingCompact targets.merope}";
              tooltip = builtins.concatStringsSep "\n" (map showPingLarge (builtins.attrValues targets));
            };
          format = "{}";
          on-click = "";
        };
        "custom/menu" = {
          return-type = "json";
          exec = jsonOutput "menu" {
            text = "";
            tooltip = ''$(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f2)'';
          };
          on-click = "${wofi} -S drun -x 10 -y 10 -W 25% -H 60%";
        };
        "custom/hostname" = {
          exec = "echo $USER@$(hostname)";
          on-click = terminal;
        };
        "custom/gammastep" = {
          interval = 5;
          return-type = "json";
          exec = jsonOutput "gammastep" {
            pre = ''
              if unit_status="$(${systemctl} --user is-active gammastep)"; then
                status="$unit_status ($(${journalctl} --user -u gammastep.service -g 'Period: ' | tail -1 | cut -d ':' -f6 | xargs))"
              else
                status="$unit_status"
              fi
            '';
            alt = "\${status:-inactive}";
            tooltip = "Gammastep is $status";
          };
          format = "{icon}";
          format-icons = {
            "activating" = " ";
            "deactivating" = " ";
            "inactive" = "? ";
            "active (Night)" = " ";
            "active (Nighttime)" = " ";
            "active (Transition (Night)" = " ";
            "active (Transition (Nighttime)" = " ";
            "active (Day)" = " ";
            "active (Daytime)" = " ";
            "active (Transition (Day)" = " ";
            "active (Transition (Daytime)" = " ";
          };
          on-click = "${systemctl} --user is-active gammastep && ${systemctl} --user stop gammastep || ${systemctl} --user start gammastep";
        };
        "custom/currentplayer" = {
          interval = 2;
          return-type = "json";
          exec = jsonOutput "currentplayer" {
            pre = ''player="$(${playerctl} status -f "{{playerName}}" 2>/dev/null || echo "No players found" | cut -d '.' -f1)"'';
            alt = "$player";
            tooltip = "$player";
          };
          format = "{icon}";
          format-icons = {
            "No players found" = "ﱘ";
            "Celluloid" = "";
            "spotify" = "阮";
            "ncspot" = "阮";
            "qutebrowser" = "爵";
            "firefox" = "";
            "discord" = "ﭮ";
            "sublimemusic" = "";
          };
          on-click = "${playerctld} shift";
          on-click-right = "${playerctld} unshift";
        };
        "custom/player" = {
          exec-if = "${playerctl} status";
          exec = ''${playerctl} metadata --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}", "tooltip": "{{title}} ({{artist}} - {{album}})"}' '';
          return-type = "json";
          interval = 2;
          max-length = 30;
          format = "{icon} {}";
          format-icons = {
            "Playing" = "契";
            "Paused" = " ";
            "Stopped" = "栗";
          };
          on-click = "${playerctl} play-pause";
        };
      };

    };
    # Cheatsheet:
    # x -> all sides
    # x y -> vertical, horizontal
    # x y z -> top, horizontal, bottom
    # w x y z -> top, right, bottom, left
    style = ''
      * {

        font-size: 12pt;
        padding: 0 8px;
      }
      .modules-right {
        margin-right: -15px;
      }
      .modules-left {
        margin-left: -15px;
      }
      window#waybar.top {
        opacity: 0.95;
        padding: 0;
        border-radius: 10px;
      }
      window#waybar.bottom {
        opacity: 0.90;
        border-radius: 10px;
      }

      #workspaces button {
        margin: 4px;
      }

      #workspaces button.focused,

      #clock {

        padding-left: 15px;
        padding-right: 15px;
        margin-top: 0;
        margin-bottom: 0;
        border-radius: 10px;
      }
      #custom-menu {

        padding-left: 15px;
        padding-right: 22px;
        margin-left: 0;
        margin-right: 10px;
        margin-top: 0;
        margin-bottom: 0;
        border-radius: 10px;
      }
      #custom-hostname {

        padding-left: 15px;
        padding-right: 18px;
        margin-right: 0;
        margin-top: 0;
        margin-bottom: 0;
        border-radius: 10px;
      }
      #tray {

      }
    '';
  };
}
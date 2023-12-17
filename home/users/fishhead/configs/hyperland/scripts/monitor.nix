{ pkgs, ...}:

let
  xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
in
  pkgs.writeShellScriptBin "monitor" ''
    monitors=$(${xrandr} --listmonitors)
    if [[ $monitors == *"DP-2"* ]]; then
      echo "DP-2"
    elif [[ $monitors == *"HDMI-A-0"* ]]; then
      echo "HDMI-A-0"
    elif [[ $monitors == *"HDMI-3"* ]]; then
      echo "HDMI-3"
    else
      echo "eDP"
    fi
  ''
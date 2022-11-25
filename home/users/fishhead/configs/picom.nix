{ pkgs, ... }:

{
  services.picom = {
    enable = true;

    activeOpacity = 1.0;
    inactiveOpacity = 0.9;

    backend = "glx";
    vSync = true;

    fade = true;
    fadeDelta = 5;

    shadow = true;
    shadowOffsets = [ (-7) (-7) ];
    shadowOpacity = 0.7;
    shadowExclude = [
      "name = 'cpt_frame_window'"
      "name = 'as_toolbar'"
      "name = 'zoom_linux_float_video_window'"
      "name = 'AnnoInputLinux'"
      "class_g = 'firefox' && argb"
      "name = 'cpt_frame_xcb_window'"
      "class_g ?= 'zoom'"
      "window_type *= 'normal' && ! name ~= ''"
      "name = 'rect-overlay'"
    ];

    settings = {
      unredir-if-possible = false;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      use-damage = false;
      blur = {
        method = "dual_kawase";
        strength = 10;
      };
      blur-background-exclude = [
        "name *= 'slop'"
        "name = 'cpt_frame_window'"
        "name = 'as_toolbar'"
        "name = 'zoom_linux_float_video_window'"
        "name = 'AnnoInputLinux'"
        "class_g = 'firefox' && argb"
        "class_g ?= 'zoom'"
        "name = 'rect-overlay'"
      ];
      opacity-rule = [
        "50:class_g = 'xest-exe'"
      ];
    };
  };
}

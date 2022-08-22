# Dunst configuration.
{ config, pkgs, lib, ...}: 

{
  home.packages = with pkgs; [
    # Ensure dmenu is available.
    dmenu

    # Ensure Adwaita icons are available.
    gnome.adwaita-icon-theme
  ];

  # Enable dunst for notifications.
  services.dunst.enable = true;

  # Global settings
  services.dunst.settings = {
    global = {
      follow = "mouse";
      geometry = "350x5-20+45";
      indicate_hidden = true;
      shrink = false;
      transparency = 20;
      notification_height = 75;
      separator_height = 2;
      padding = 10;
      horizontal_padding = 10;
      frame_width = 2;
      sort = true;
      idle_threshold = 120;
      line_height = 5;
      markup = "full";
      format = "<b>%s</b>\\n%b";
      # format = "<i>%a</i>: <b>%s</b>\\n%b\\n%p";
      alignment = "left";
      show_age_threshold = 60;
      word_wrap = true;
      ignore_newline = false;
      stack_duplicates = true;
      hide_duplicate_count = false;
      show_indicators = true;
      icon_position = "right";

      # Show important messages from dunst in logs.
      verbosity = "mesg";

      # Show a mesage on dunst startup just to know it's been properly
      # (re)started by dbus.
      startup_notification = "true";
      # Scale icons to 32x32.
      min_icon_size = 32;
      max_icon_size = 32;
      # The icon path, overridden here to avoid using system icons.
      icon_path =
        let
          # The icon size to use.
          iconSize = "scalable";

          # The categories for the Adwaita icons.
          adwaitaCategories = [
            "actions"
            "apps"
            "categories"
            "devices"
            "emblems"
            "emotes"
            "legacy"
            "mimetypes"
            "places"
            "status"
            "ui"
          ];

          # The path to each Adwaita icon category in the profile.
          adwaitaIcons =
            let
              # The base path to all icons.
              basePath = "${config.home.profileDirectory}/share/icons";

              # The path to all icons of our chosen size.
              sizePath = "${basePath}/Adwaita/${iconSize}";
            in
            map (cat: "${sizePath}/${cat}") adwaitaCategories;

          # The path to the default icons.
          iconPath = builtins.concatStringsSep ":" adwaitaIcons;
        in
        lib.mkForce iconPath;
        
      # Put an ellipsis in the middle of the text when it can't fit.
      # NOTE: This doesn't apply when doing word wrapping and is just here for
      # completeness.
      ellipsize = "middle";
      # Don't round notification window corners.
      corner_radius = 0;
      # Enable the progress bar feature for percentages.
      # This seems to only be in dunst's master for the moment, but is here
      # for when it gets into a release.
      progress_bar = true;

      # The progress bar height, including frame.
      progress_bar_height = 10;

      # The width of the progress bar frame.
      progress_bar_frame_width = 1;

      # The minimum and maximum width of the progress bar.
      progress_bar_min_width = 250;
      progress_bar_max_width = 250;


      # Don't force Xinerama for multi-monitor support.
      # Use RandR instead.
      force_xinerama = false;
      # History
      sticky_history = true;
      history_length = 20;

      browser = "firefox -new-tab";
      always_run_script = true;
      title = "Dunst";
      class = "Dunst";
      
      # Font settings
      # TODO: Ensure that this font is installed or use another one
      font = "JetBrains Mono 10";

      # Colors
      frame_color = "#4C566A";
      separator_color = "frame";
    };

    urgency_low = {
      background = "#3b4252";
      foreground = "#eceff4";
      frame_color = "#4c566a";
      timeout = 10;
    };

    urgency_normal = {
      background = "#3b4252";
      foreground = "#eceff4";
      timeout = 10;
    };

    urgency_critical = {
      background = "#3b4252";
      foreground = "#eceff4";
      frame_color = "#bf616a";
      timeout = 0;
    };
  
    # Scripting    
    brightness = {
      summary = "󰃞 Light";
      set_stack_tag = "brightness";
    };

    music = {
      summary = "*Now Playing*";
      set_stack_tag = "music";
    };

    DND = {
      summary = "*Do Not Disturb*";
      set_stack_tag = "dnd";
    };
  };
}
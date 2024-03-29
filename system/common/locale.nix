{ pkgs, lib, ... }: {

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  console = {
    # Set terminal font
    font = "cyr-sun16";
    # Use Ctrl+Shift to switch between layouts
    keyMap = "ruwin_ct_sh-UTF-8";
  };

  environment.sessionVariables = lib.mkDefault {
    XKB_DEFAULT_LAYOUT = "us,ru";
    XKB_DEFAULT_OPTIONS = "grp:caps_toggle,grp_led:caps";
    LANG = "en_US.UTF-8";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
}

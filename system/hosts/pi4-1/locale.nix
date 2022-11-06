{ pkgs, ... }: {

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  console = {
    # Set terminal font
    font = "cyr-sun16";
    # Use Ctrl+Shift to switch between layouts
    keyMap = "ruwin_ct_sh-UTF-8";
  };

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "us";
    LANG = "en_US.UTF-8";
  };

}

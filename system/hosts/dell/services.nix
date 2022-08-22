{ config, pkgs, ... }: {
  
  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us,ru";
      xkbOptions = "grp:caps_toggle,grp_led:caps";

      # Enable touchpad support.
      libinput.enable = true;

      # Enable lightdm
      displayManager.lightdm.enable = true;
      displayManager.lightdm.greeters.gtk.cursorTheme.name = "Adwaita-dark";
      displayManager.lightdm.greeters.gtk.theme.name = "Adwaita-dark";
      desktopManager.xterm.enable = true;
      windowManager.i3.enable = true;
    };
    
    # Enable ACPI deamon. When an event occurs, it executes
    # programs to handle the event. These events are triggered
    # by certain actions, such as:
    # - Pressing special keys, including the Power/Sleep/Suspend button
    # - Closing a notebook lid
    # - (Un)Plugging an AC power adapter from a notebook
    # - (Un)Plugging phone jack etc
    acpid.enable = true;

    # Optimize battery
    tlp.enable = false;
    tlp.extraConfig = "USB_AUTOSUSPEND=0";
    
    usbmuxd.enable = true;
    
    blueman.enable = true;
    
    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
    };
    
    # Enable scanner support
    # Docs: https://nixos.wiki/wiki/Scanners
    saned.enable = true;
  };

}

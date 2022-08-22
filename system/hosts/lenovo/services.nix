{ config, pkgs, ... }: {
  
  services = {    
    usbmuxd.enable = true;
    blueman.enable = true;
  };
  
}

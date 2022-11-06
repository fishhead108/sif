{ config, lib, pkgs, ... }:

{  
  services = {
    fwupd.enable = false;
    geoclue2.enable = false;
    avahi.enable = false;
    fstrim.enable = false;
    gvfs.enable = false;
    pcscd.enable = false;
    thermald.enable = false;
    usbmuxd.enable = false;
    gnome.gnome-keyring.enable = false;
  };
}
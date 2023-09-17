{ config, pkgs, lib, ... }:

{
  security.pam.u2f.enable = lib.mkDefault true;
  security.pam.u2f.interactive = lib.mkDefault true;
  security.pam.u2f.cue = lib.mkDefault true;
  
  # Set authentication to required (you will always needed to use Yubikey with password). Default if sufficient 
  security.pam.u2f.control = "sufficient";
  security.pam.u2f.appId = "pam://${config.networking.hostName}";

  # Disable u2fAuth for all these modules
  # I only want to enable u2fAuth for ssh, sudo and su really
  security.pam.services = {
    chpasswd.u2fAuth = lib.mkDefault true;
    i3lock.u2fAuth = lib.mkDefault true;
    i3lock-color.u2fAuth = lib.mkDefault true;
    lightdm.u2fAuth = lib.mkDefault true;
    lightdm-autologin.u2fAuth = lib.mkDefault true;
    lightdm-greeter.u2fAuth = lib.mkDefault true;
    login.u2fAuth = lib.mkDefault true;
    passwd.u2fAuth = lib.mkDefault true;
    runuser.u2fAuth = lib.mkDefault true;
    runuser-l.u2fAuth = lib.mkDefault true;
    swaylock.u2fAuth = lib.mkDefault true;
    xlock.u2fAuth = lib.mkDefault true;
    vlock.u2fAuth = lib.mkDefault true;
    xscreensaver.u2fAuth = lib.mkDefault true;
  };
}
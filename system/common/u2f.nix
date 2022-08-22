{ config, pkgs, lib, ... }:

{
  security.pam.u2f.enable = true;
  security.pam.u2f.interactive = true;
  security.pam.u2f.cue = true;
  
  # Set authentication to required (you will always needed to use Yubikey with password). Default if sufficient 
  security.pam.u2f.control = "sufficient";
  security.pam.u2f.appId = "pam://${config.networking.hostName}";

  # Disable u2fAuth for all these modules
  # I only want to enable u2fAuth for ssh, sudo and su really
  security.pam.services = {
    chpasswd.u2fAuth = true;
    i3lock.u2fAuth = true;
    i3lock-color.u2fAuth = true;
    lightdm.u2fAuth = true;
    lightdm-autologin.u2fAuth = true;
    lightdm-greeter.u2fAuth = true;
    login.u2fAuth = true;
    passwd.u2fAuth = true;
    runuser.u2fAuth = true;
    runuser-l.u2fAuth = true;
    swaylock.u2fAuth = true;
    xlock.u2fAuth = true;
    vlock.u2fAuth = true;
    xscreensaver.u2fAuth = true;
  };

    # Get notifications when waiting for my yubikey
    # services.yubikey-touch-detector.enable = true;
}
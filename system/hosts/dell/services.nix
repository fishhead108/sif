{ config, pkgs, lib, ... }: 

{

  # # Copy my avatar to help. It will fail without internet connection
  # systemd.services.accounts-daemon.serviceConfig.ExecStartPre = pkgs.writeShellScript "userAvatar" ''
  #   ${pkgs.wget}/bin/wget https://github.com/fishhead108/sif/raw/main/home/users/fishhead/fishhead.png -O /var/lib/AccountsService/icons/fishhead

  #   cat <<EOF | tee /var/lib/AccountsService/users/fishhead
  #   [User]
  #   XSession=none+i3
  #   Icon=/var/lib/AccountsService/icons/fishhead
  #   SystemAccount=false
  #   EOF
  # '';

  # Copy my avatar to help accounts-daemon. It will fail without internet connection
  systemd.services.userAvatar = {
    unitConfig = {
      Description = "Configure user avatart during initial startup";
      After = [ "network-online.target" ];
      Before = [ "systemd-user-sessions.service" "accounts-daemon.service" ];
      Wants = [ "network-online.target" ];
      ConditionPathExists = "!/var/lib/AccountsService/users/fishhead";
    };
    
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "" + pkgs.writeScript "user_avatar" ''
        #!${pkgs.stdenv.shell} --login
        ${pkgs.wget}/bin/wget https://github.com/fishhead108/sif/raw/main/home/users/fishhead/fishhead.png -O /var/lib/AccountsService/icons/fishhead
        cat <<EOF | tee /var/lib/AccountsService/users/fishhead
        [User]
        XSession=none+i3
        Icon=/var/lib/AccountsService/icons/fishhead
        SystemAccount=false
        EOF
      '';

      ExecStartPost = with pkgs; ''
        ${pkgs.coreutils-full}/bin/touch /var/lib/AccountsService/users/fishhead
      '';
      RemainAfterExit = "yes";
    };
    
    wantedBy = [ "multi-user.target" ];
  };

  services = {
    # AccountsService is a D-Bus service for accessing the list of user accounts and information attached to those accounts.
    accounts-daemon.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us,ru,fr";
      xkbOptions = "grp:caps_toggle,grp_led:caps";

      # Enable touchpad support.
      libinput.enable = true;

      # smartd = {
      #   enable = true;
      #   notifications.x11.enable = true;
      # };

      # Enable lightdm
      displayManager.lightdm = {
        enable = true;
         
        # extraConfig = ''
        #   greeter-hide-users=false
        #   user-session=fishhead
        #   default-user=fishhead
        # '';

        # extraSeatDefaults = ''
        #   default-user=fishhead
        #   greeter-hide-users=false
        #   user-session=fishhead
        #   greeter-show-manual-login=true
        # '';

        greeters.gtk = {
          enable = true;
          cursorTheme.name = "Adwaita-dark";
          theme.name = "Adwaita-dark";
          indicators = [ "~host" "~spacer" "~clock" "~spacer" "~power" ];
        };
      };
      
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
      # drivers = [ pkgs.hplip ];
    };
    
    # Enable scanner support
    # Docs: https://nixos.wiki/wiki/Scanners
    saned = {
      enable = true;
      # extraBackends = [ pkgs.hplipWithPlugin ];
    };
  };
}

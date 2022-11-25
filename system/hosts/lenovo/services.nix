{ config, pkgs, ... }: {
  
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

    flatpak.enable = true;

    # AccountsService is a D-Bus service for accessing the list of user accounts and information attached to those accounts.
    accounts-daemon.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us,ru,fr";
      xkbOptions = "grp:caps_toggle,grp_led:caps";

      # Enable touchpad support.
      libinput.enable = true;

      # Enable lightdm
      displayManager.lightdm = {
        enable = true;
         
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

    usbmuxd.enable = true;
    blueman.enable = true;
  };
  
}

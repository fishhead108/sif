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

    # For Vagrant
    nfs.server.enable = true;

    flatpak.enable = true;

    # AccountsService is a D-Bus service for accessing the list of user accounts and information attached to those accounts.
    accounts-daemon.enable = true;

    # ssh
    # openssh = {
    #   settings = {
    #     passwordAuthentication = false;
    #     kbdInteractiveAuthentication = false;
    #     permitRootLogin = "no";
    #   };
    # };

    # pipewire = {
    #   enable = true;
    #   alsa.enable = true;
    #   alsa.support32Bit = true;
    #   pulse.enable = true;
    #   # If you want to use JACK applications, uncomment this
    #   #jack.enable = true;
    # };

    pipewire = {
      enable = true;
      alsa.enable = true;
      # No idea if I need this
      alsa.support32Bit = true;
      pulse.enable = true;

      # # High quality BT calls
      # media-session.config.bluez-monitor.rules = [
      #   {
      #     # Matches all cards
      #     matches = [{ "device.name" = "~bluez_card.*"; }];
      #     actions = {
      #       "update-props" = {
      #         "bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
      #       };
      #     };
      #   }
      #   {
      #     matches = [
      #       # Matches all sources
      #       { "node.name" = "~bluez_input.*"; }
      #       # Matches all outputs
      #       { "node.name" = "~bluez_output.*"; }
      #     ];
      #     actions = {
      #       "node.pause-on-idle" = false;
      #     };
      #   }
      # ];
    };

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us,ru";
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

    blueman.enable = true;

    # syncthing = {
    #   enable = true;
    #   dataDir = "/home/fishhead/Documents";
    #   configDir = "/home/fishhead/.config/syncthing";
    #   overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    #   overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    #   devices = {
    #     "ipad" = { id = "XQXJNYK-ZCC3XRD-CBLASET-P4LPXES-CIUWI32-SYSEUG7-IUNUCMW-4PVCCQA"; };
    #     # "device2" = { id = "DEVICE-ID-GOES-HERE"; };
    #   };
    #   folders = {
    #     "Documents" = {        # Name of folder in Syncthing, also the folder ID
    #       path = "/home/fishhead/Documents";    # Which folder to add to Syncthing
    #       devices = [ "ipad" ];      # Which devices to share the folder with
    #     };
    #     "TGD" = {
    #       path = "/home/fishhead/Downloads/Telegram Desktop";
    #       devices = [ "ipad" ];
    #       ignorePerms = false;     # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
    #     };
    #   };
    # };
  };  
}

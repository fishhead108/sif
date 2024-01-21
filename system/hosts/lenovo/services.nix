{ config, pkgs, ... }: 
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in
{
  
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

  environment.etc = {
    "flatpak/remotes.d/flathub.flatpakrepo".source = pkgs.fetchurl {
      url = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      # Let this run once and you will get the hash as an error.
      hash = "sha256-M3HdJQ5h2eFjNjAHP+/aFTzUQm9y9K+gwzc64uj+oDo=";
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  services = {

    dbus.enable = true;
  
    # greetd = {
    #   enable = true;
    #   settings = rec {
    #     initial_session = {
    #       command = "Hyprland";
    #       user = "fishhead";
    #     };
    #     default_session = initial_session;
    #   };
    # };

    # greetd = {
    #   enable = true;
    #   settings.default_session = {
    #     command = "${pkgs.greetd.wlgreet}/bin/wlgreet";
    #     user = "fishhead";
    #   };
    # };

    opensnitch.enable = false;
    
    rpcbind.enable = true;

    yubikey-agent.enable = true;

    # For Vagrant
    nfs.server.enable = true;

    flatpak.enable = true;

    # AccountsService is a D-Bus service for accessing the list of user accounts and information attached to those accounts.
    accounts-daemon.enable = true;

    # Enable the X11 windowing system.
    # xserver = {
    #   enable = true;
    #   layout = "us,ru";
    #   xkbOptions = "grp:caps_toggle,grp_led:caps";

    #   # Enable touchpad support.
    #   libinput.enable = true;

    #   # Enable lightdm
    #   displayManager.lightdm = {
    #     enable = true;
         
    #     greeters.gtk = {
    #       enable = true;
    #       cursorTheme.name = "Adwaita-dark";
    #       theme.name = "Adwaita-dark";
    #       indicators = [ "~host" "~spacer" "~clock" "~spacer" "~power" ];
    #     };
    #   };
      
    #   desktopManager.xterm.enable = true;
    #   windowManager.i3.enable = true;
    # };

    ### Wayland
    # xserver = {
    #   enable = true;
    #   layout = "us,ru";
    #   xkbOptions = "grp:caps_toggle,grp_led:caps";

    #   # Enable touchpad support.
    #   libinput.enable = true;

    #   # smartd = {
    #   #   enable = true;
    #   #   notifications.x11.enable = true;
    #   # };

    #   # Enable lightdm
    #   displayManager.lightdm = {
    #     enable = false;
         
    #     # extraConfig = ''
    #     #   greeter-hide-users=false
    #     #   user-session=fishhead
    #     #   default-user=fishhead
    #     # '';

    #     # extraSeatDefaults = ''
    #     #   default-user=fishhead
    #     #   greeter-hide-users=false
    #     #   user-session=fishhead
    #     #   greeter-show-manual-login=true
    #     # '';

    #     greeters.gtk = {
    #       enable = true;
    #       cursorTheme.name = "Adwaita-dark";
    #       theme.name = "Adwaita-dark";
    #       indicators = [ "~host" "~spacer" "~clock" "~spacer" "~power" ];
    #     };
    #   };
      
    #   desktopManager.xterm.enable = true;
    #   windowManager.i3.enable = false;
    # };

    blueman.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

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

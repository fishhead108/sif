{ pkgs, config, lib, ... }: {

  environment = {
    # QT4/5 global theme
    etc."xdg/Trolltech.conf" = {
      text = ''
        [Qt]
        style=GTK+
      '';
      mode = "444";
    };
      
    shellInit = lib.mkDefault ''
      # export QT_STYLE_OVERIDE=Adwaita-dark
      # export QT_QPA_PLATFORMTHEME=qt5ct
      if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
        export GPG_TTY="$(tty)"
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
      fi
    '';

    sessionVariables = rec {
      HOSTNAME        = config.networking.hostName;
      XDG_CACHE_HOME  = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME    = "\${HOME}/.local/bin";
      XDG_DATA_HOME   = "\${HOME}/.local/share";

      PATH = [ 
        "\${XDG_BIN_HOME}"
      ];
    };

    variables = {
      HOSTNAME        = config.networking.hostName;
    };

    systemPackages = with pkgs; [
      wget                                # Tool for retrieving files using HTTP, HTTPS, and FTP
      curl                                # A command line tool for transferring files with URL syntax
      git                                 # Distributed version control system
      pv                                  # Tool for monitoring the progress of data through a pipeline
      home-manager                        # A user environment configurator
      brightnessctl                       # This program allows you read and control device brightness
      ddcutil                             # Query and change Linux monitor settings using DDC/CI and USB.
      ccid                                # ccid drivers for pcsclite
      pcsclite                            # Middleware to access a smart card using SCard API (PC/SC)
      libimobiledevice                    # A software library that talks the protocols to support iPhone®, iPod Touch® and iPad® devices on Linux
      alsa-utils                          # ALSA, the Advanced Linux Sound Architecture utils
      pamixer                             # Pulseaudio command line mixer
      paprefs                             # PulseAudio Preferences
      pavucontrol                         # PulseAudio Volume Control
      pulsemixer                          # Cli and curses mixer for pulseaudio
      alsaUtils
      broadcom-bt-firmware                # Firmware for Broadcom WIDCOMM® Bluetooth devices
      tailscale                           # The node agent for Tailscale, a mesh VPN built on WireGuard
      man-pages                           # Linux development manual pages
      man-pages-posix                     # POSIX man-pages (0p, 1p, 3p)
      gcr                                 # GNOME crypto services (daemon and tools)
      gnome.gnome-keyring                 # Collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications
      gnome.libgnome-keyring              # Framework for managing passwords and other secret
      libsForQt5.qt5.qtgraphicaleffects   # A cross-platform application framework for C++
      libsecret                           # A library for storing and retrieving passwords and other secrets
      gnupg                               # Modern release of the GNU Privacy Guard, a GPL OpenPGP implementation            
      pinentry-qt                         # GnuPG’s interface to passphrase input
      pinentry-gnome                      # GnuPG’s interface to passphrase input
      pinentry-curses                     # GnuPG’s interface to passphrase input
      libnotify                           # A library that sends desktop notifications to a notification daemon
      accountsservice                     # D-Bus interface for user account query and manipulation
      ranger                              # File manager with minimalistic curses interface
      geoclue2                            # Geolocation framework and some data providers
      dnsutils                            # network: dig
      coreutils-full                      # The basic file, shell and text manipulation utilities of the GNU operating system
      iproute2                            # A collection of utilities for controlling TCP/IP networking and traffic control in Linux
      wirelesstools                       # network: iwgetid
      nix-tree                            # Interactively browse a Nix store paths dependencies
      deploy-rs                           # A simple multi-profile Nix-flake deploy tool.
    ];
  };
  
  programs = {
    neovim.enable = true;
    
    neovim.viAlias = true;

    # Whether to enable iftop + setcap wrapper.
    iftop.enable = true;

    # Whether to enable iotop + setcap wrapper.
    iotop.enable = true;

    # Whether to add mtr to the global environment and configure a setcap wrapper for it.
    mtr.enable = true;

    # Whether to enable Bash completion for all interactive bash shells.
    bash.enableCompletion = true;

    # Whether to install Light backlight control command and udev rules granting access to members of the "video" group.
    light.enable = true;

    dconf.enable = true;

    mosh.enable = true;

    ssh.startAgent = false;

    gnupg.agent = {
      enable = lib.mkDefault true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
  };

}

{ pkgs, config, lib, ... }: 
{

  xdg = {
    # Needed for Flatpak
    portal.enable = lib.mkDefault false;
    portal.extraPortals = [ ];
  };

  environment = {
    # QT4/5 global theme
    # etc."xdg/Trolltech.conf" = {
    #   text = ''
    #     [Qt]
    #     style=GTK+
    #   '';
    #   mode = "444";
    # };
      
    # shellInit = lib.mkDefault ''
    #   # export QT_STYLE_OVERIDE=Adwaita-dark
    #   # export QT_QPA_PLATFORMTHEME=qt5ct
    #   # if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
    #   #   export GPG_TTY="$(tty)"
    #   #   gpg-connect-agent /bye
    #   #   export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    #   # fi
    # '';

    # persistence = {
    #   "/persist".directories = [ "/var/lib/tailscale" ];
    # };

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
      accountsservice                     # D-Bus interface for user account query and manipulation
      alsa-utils                          # ALSA, the Advanced Linux Sound Architecture utils
      brightnessctl                       # This program allows you read and control device brightness
      broadcom-bt-firmware                # Firmware for Broadcom WIDCOMM® Bluetooth devices
      ccid                                # ccid drivers for pcsclite
      coreutils-full                      # The basic file, shell and text manipulation utilities of the GNU operating system
      curl                                # A command line tool for transferring files with URL syntax
      ddcutil                             # Query and change Linux monitor settings using DDC/CI and USB.
      deploy-rs                           # A simple multi-profile Nix-flake deploy tool.
      dnsutils                            # network: dig
      dpkg                                # The Debian package manager
      findutils                           # GNU Find Utilities, the basic directory searching utilities of the GNU operating system
      gcr                                 # GNOME crypto services (daemon and tools)
      geoclue2                            # Geolocation framework and some data providers
      git                                 # Distributed version control system
      git-crypt                           # Transparent file encryption in git
      gnome.gnome-keyring                 # Collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications
      gnome.libgnome-keyring              # Framework for managing passwords and other secret
      gnupg                               # Modern release of the GNU Privacy Guard, a GPL OpenPGP implementation            
      home-manager                        # A user environment configurator
      iproute2                            # A collection of utilities for controlling TCP/IP networking and traffic control in Linux
      libimobiledevice                    # A software library that talks the protocols to support iPhone®, iPod Touch® and iPad® devices on Linux
      libnotify                           # A library that sends desktop notifications to a notification daemon
      libsecret                           # A library for storing and retrieving passwords and other secrets
      libsForQt5.qt5.qtgraphicaleffects   # A cross-platform application framework for C++
      man-pages                           # Linux development manual pages
      man-pages-posix                     # POSIX man-pages (0p, 1p, 3p)
      nix-tree                            # Interactively browse a Nix store paths dependencies
      pamixer                             # Pulseaudio command line mixer
      paprefs                             # PulseAudio Preferences
      pavucontrol                         # PulseAudio Volume Control
      pcsclite                            # Middleware to access a smart card using SCard API (PC/SC)
      pinentry-curses                     # GnuPG’s interface to passphrase input
      pinentry-gnome                      # GnuPG’s interface to passphrase input
      pinentry-qt                         # GnuPG’s interface to passphrase input
      procps                              # Utilities that give information about processes using the /proc filesystem
      psmisc                              # A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
      pulsemixer                          # Cli and curses mixer for pulseaudio
      pv                                  # Tool for monitoring the progress of data through a pipeline
      ranger                              # File manager with minimalistic curses interface
      tailscale                           # The node agent for Tailscale, a mesh VPN built on WireGuard
      tree                                # Command to produce a depth indented directory listing
      wget                                # Tool for retrieving files using HTTP, HTTPS, and FTP
      wirelesstools                       # network: iwgetid
    ];
  };
  
  programs = {

    # Whether to enable the 1Password GUI application.
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "fishhead" ];
    };

    # Whether to enable Neovim.
    # When enabled through this option, Neovim is wrapped to use a configuration managed by this module. 
    # The configuration file in the user’s home directory at ~/.config/nvim/init.vim is no longer loaded by default.
    neovim.enable = lib.mkDefault false;
    
    # Symlink vi to nvim binary.
    neovim.viAlias = lib.mkDefault false;

    # Whether to enable iftop + setcap wrapper.
    iftop.enable = lib.mkDefault true;

    # Whether to enable iotop + setcap wrapper.
    iotop.enable = lib.mkDefault true;

    # Whether to add mtr to the global environment and configure a setcap wrapper for it.
    mtr.enable = lib.mkDefault true;

    # Whether to enable Bash completion for all interactive bash shells.
    bash.enableCompletion = lib.mkDefault true;

    # Whether to install Light backlight control command and udev rules granting access to members of the "video" group.
    light.enable = lib.mkDefault false;

    # Whether to enable dconf.
    # dconf is a low-level configuration system. 
    # Its main purpose is to provide a backend to GSettings on platforms that don't already have configuration storage systems.
    dconf.enable = lib.mkDefault true;

    # Whether to enable mosh. Note, this will open ports in your firewall!
    mosh.enable = lib.mkDefault true;

    # Whether to start the OpenSSH agent when you log in. 
    # The OpenSSH agent remembers private keys for you so that you don’t have to type in passphrases 
    # every time you make an SSH connection. Use ssh-add to add a key to the agent.
    ssh.startAgent = lib.mkDefault false;

    # Enables GnuPG agent with socket-activation for every user session.
    gnupg.agent = {
      enable = lib.mkDefault false;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
  };

}

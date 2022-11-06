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
      
    shellInit = "";

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
      findutils                           #
      procps                              #
      psmisc                              # A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
      wget                                # Tool for retrieving files using HTTP, HTTPS, and FTP
      curl                                # A command line tool for transferring files with URL syntax
      git                                 # Distributed version control system
      pv                                  # Tool for monitoring the progress of data through a pipeline
      home-manager                        # A user environment configurator
      tailscale                           # The node agent for Tailscale, a mesh VPN built on WireGuard
      libsecret                           # A library for storing and retrieving passwords and other secrets
      pinentry-curses                     # GnuPG’s interface to passphrase input
      dnsutils                            # network: dig
      coreutils-full                      # The basic file, shell and text manipulation utilities of the GNU operating system
      iproute2                            # A collection of utilities for controlling TCP/IP networking and traffic control in Linux
      deploy-rs                           # A simple multi-profile Nix-flake deploy tool.
    ];
  };
  
  programs = {

    neovim.enable = false;
    
    neovim.viAlias = false;

    iftop.enable = false;

    iotop.enable = false;

    mtr.enable = false;

    bash.enableCompletion = false;

    light.enable = false;

    dconf.enable = false;

    mosh.enable = false;

    ssh.startAgent = false;

    gnupg.agent = {
      enable = false;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
  };

}

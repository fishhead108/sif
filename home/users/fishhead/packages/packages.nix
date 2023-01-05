{pkgs, ...}:
{
  home.packages = with pkgs; [

    # Appearance
    rofi-systemd                    # Control your systemd units using rofi
    gsettings-desktop-schemas       # Collection of GSettings schemas for settings shared by various components of a desktop
    xdg-utils                       # A set of command line tools that assist applications with a variety of desktop integration tasks
    xdg-user-dirs                   # A tool to help manage well known user directories like the desktop folder and the music folder
    xfce.thunar                     # Xfce file manager
    xfce.thunar-volman              # Thunar extension for automatic management of removable drives and media
    networkmanagerapplet            # NetworkManager control applet for GNOME
    xorg.xprop                      # The xprop utility is for displaying window and font properties in an X server
    xclip                           # Tool to access the X clipboard from a console application
    gtk-engine-murrine              # A very flexible theme engine
    gtk_engines                     # Theme engines for GTK 2
    xscreensaver                    # A set of screensavers
    arandr                          # A simple visual front end for XRandR
    brightnessctl                   # This program allows you read and control device brightness
    xfce.xfce4-power-manager        # A power manager for the Xfce Desktop Environment
    i3lock-pixeled                  # Simple i3lock helper which pixels a screenshot
    i3lock-fancy                    # i3lock is a bash script that takes a screenshot of the desktop, blurs the background and adds a lock icon and text
    i3lock-color                    # A simple screen locker like slock, enhanced version with extra configuration options
    mime-types                      # 
    lxappearance                    # Lightweight program for configuring the theme and fonts of gtk applications
    qt5ct                           # Qt5 Configuration Too
    adwaita-qt                      # A style to bend Qt applications to look like they belong into GNOME Shell
    libsForQt5.qtstyleplugins       # Additional style plugins for Qt5, including BB10, GTK, Cleanlooks, Motif, Plastique
    unclutter                       # Hides mouse pointer while not in use
    numix-solarized-gtk-theme       # Solarized versions of Numix GTK2 and GTK3 theme
    numix-cursor-theme              # Numix cursor theme
    numix-icon-theme                # Numix icon theme

    # Helpers
    rescuetime              # Helps you understand your daily habits so you can focus and be more productive
    obsidian                # A powerful knowledge base that works on top of a local folder of plain text Markdown files
    anki-bin                # Spaced repetition flashcard program
    mpv                     # General-purpose media player, fork of MPlayer and mplayer2
    ledger-live-desktop     # Wallet app for Ledger Nano S and Ledger Blue
    appimage-run
    restic                  # A backup program that is fast, efficient and secure
    remmina                 # Remote desktop client written in GTK

    # Terminal
    termite                 # A simple VTE-based terminal
    termius                 # A cross-platform SSH client with cloud data sync and more
    wtf                     # The personal information dashboard for your terminal
    gh                      # GitHub CLI tool
    htop                    # An interactive process viewer
    neofetch                # A fast, highly customizable system info script
    tmux                    # Terminal multiplexer
    which                   # Shows the full path of (shell) commands

    # Development
    jq                      # A lightweight and flexible command-line JSON processor
    git-crypt               # Transparent file encryption in git
    git-sizer               # Compute various size metrics for a Git repository
    lazygit                 # Simple terminal UI for git commands
    python39Full            # A high-level dynamically-typed programming language
    openssl_3               # A cryptographic library that implements the SSL and TLS protocols
    d2                      # A modern diagram scripting language that turns text to diagrams
    python310Packages.pipx  # Install and Run Python Applications in Isolated Environments
    # gcc                     # GNU Compiler Collection, version 11.3.0 (wrapper script)
    fx                      # Terminal JSON viewer
    
    # Documents
    evince                  # GNOME's document viewer
    libreoffice             # Linux office
    unzip                   # An extraction utility for archives compressed in .zip format
    zstd                    # Zstandard real-time compression algorithm
    libsForQt5.okular       # KDE document viewer
    foliate                 # A simple and modern GTK eBook reader

    # Sec
    _1password              # 1Password command-line tool
    _1password-gui          # Multi-platform password manager
    keepassxc               # Offline password manager with many features.
    rofi-pass               # A script to make rofi work with password-store
    protonvpn-gui           # Official ProtonVPN Linux app
    tor                     # Anonymizing overlay network
    tor-browser-bundle-bin  # Tor Browser Bundle built by torproject.org
    
    # Media
    youtube-dl              # Command-line tool to download videos from YouTube.com and other sites
    imagemagick             # A software suite to create, edit, compose, or convert bitmap images
    spotify                 # Play music from the Spotify music service
    simplescreenrecorder    # A screen recorder for Linux
    vlc                     # Cross-platform media player and streaming server
    feh                     # A light-weight image viewer
    flameshot               # Powerful yet simple to use screenshot software
    audacity                # Sound editor with graphical UI
    
    # Sound 
    lxqt.pavucontrol-qt     # A Pulseaudio mixer in Qt (port of pavucontrol)
    pasystray               # PulseAudio system tray

    # Browsers
    google-chrome                           # A freeware web browser developed by Google
    (wrapFirefox firefox-bin-unwrapped {    # Mozilla Firefox, free web browser (binary package)
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = false;
        UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
        };
        FirefoxHome = {
        Search = false;
        TopSites = false;
        Highlights = false;
        Pocket = false;
        Snippets = false;
        };
        Homepage = {
        StartPage = "none";
        };
        NewTabPage = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        PasswordManagerEnabled = false;
        Bookmarks = [
          {
              Title = "Google";
              URL = "https://google.com";
              Favicon = "https://google.com/favicon.ico";
              Placement = "toolbar";
          }
        ];
      };
    })

    # Chats
    tdesktop                                # Telegram Desktop messaging app
    skypeforlinux                           # Linux client for skype
    zoom-us                                 # zoom.us video conferencing application
    teams                                   # Microsoft Teams
    discord                                 # All-in-one cross-platform voice and text chat for gamers
    slack                                   # Desktop client for Slack

    # Ops tools
    awscli2                                 # Unified tool to manage your AWS services
    aws-vault                               # A vault for securely storing and accessing AWS credentials in development environments
    ansible                                 # Radically simple IT automation
    tflint                                  # Terraform linter focused on possible errors, best practices, and so on
    packer                                  # A tool for creating identical machine images for multiple platforms from a single source configuration
    helmfile                                # Deploy Kubernetes Helm charts
    terragrunt                              # A thin wrapper for Terraform that supports locking for Terraform state and enforces best practices
    terraform                               # Tool for building, changing, and versioning infrastructure
    terraform-providers.aws                 # 
    terraform-providers.docker              # 
    terraform-providers.kubernetes          # 
    krew                                    # Package manager for kubectl plugins
    kubectl                                 # Kubernetes CLI
    kubectx                                 # Fast way to switch between clusters and namespaces in kubectl!
    kubernetes-helm                         # A package manager for kubernetes
    lens                                    # The Kubernetes IDE
    vagrant                                 # A tool for building complete development environments
    minikube                                # A tool that makes it easy to run Kubernetes locally
    docker-compose                          # Multi-container orchestration for Docker
    cloud-nuke                              # A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it
  ];
}
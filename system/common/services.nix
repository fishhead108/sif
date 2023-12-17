{ config, pkgs, lib, ... }: 
{  
  services = {

    # Whether to enable fprintd daemon and PAM module for fingerprint readers handling.
    fprintd.enable = lib.mkDefault true;

    # Whether to start yubikey-agent when you log in. Also sets SSH_AUTH_SOCK to point at yubikey-agent.
    # Note that yubikey-agent will use whatever pinentry is specified in programs.gnupg.agent.pinentryFlavor.
    yubikey-agent.enable = lib.mkDefault false;

    # Enable localtimed, a simple daemon for keeping the system timezone up-to-date based on the current location. 
    # It uses geoclue2 to determine the current location.
    localtimed.enable = lib.mkDefault false;

    # Extra config options for systemd-journald. 
    # See man journald.conf for available options.
    journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=7day
    '';
    
    # Enable a deamon that allows updating some devices
    # firmware, including UEFI for several machines
    fwupd.enable = lib.mkDefault true;

    # List of packages containing udev rules. All files found in pkg/etc/udev/rules.d and pkg/lib/udev/rules.d will be included.
    udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
    
    # Whether to enable GeoClue 2 daemon, a DBus service that provides location information for accessing.
    geoclue2.enable = lib.mkDefault true;

    # Enable programs to publish and discover services and
    # hosts running on a local network. For example, a user can
    # plug a computer into a network and have Avahi
    # automatically advertise the network services running on
    # its machine, facilitating user access to those services
    avahi = {
      enable = lib.mkDefault true;
      nssmdns4 = true;
    };

    # Whether to enable periodic SSD TRIM of mounted partitions in background.
    fstrim.enable = lib.mkDefault true;

    # Whether to enable GVfs, a userspace virtual filesystem.
    # GVfs comes with a set of backends, including trash support, SFTP, SMB, HTTP, DAV, and many others - https://wiki.gnome.org/Projects/gvfs/schemes
    gvfs = {
      enable = lib.mkDefault true;
      package = lib.mkForce pkgs.gnome.gvfs;
    };

    # Whether to enable PCSC-Lite daemon.
    # Smartcard support
    pcscd.enable = lib.mkDefault true;

    # ssh
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
      extraConfig = "AllowUsers fishhead deployer nixos\nPermitEmptyPasswords no\nClientAliveInterval 300\nClientAliveCountMax 0";
    };
    
    # Packages whose D-Bus configuration files should be included in the configuration of the D-Bus system-wide or session-wide message bus. 
    # Specifically, files in the following directories will be included into their respective DBus configuration paths
    dbus.packages = with pkgs; [ dconf ];

    # Whether to enable Tailscale client daemon.
    tailscale.enable = lib.mkDefault true;

    # Use the systemd-timesyncd SNTP client to sync the system clock (enabled by default)
    timesyncd.enable = lib.mkDefault true;

    # Thermals and cooling
    thermald.enable = lib.mkDefault false;

    # Enable the usbmuxd (“USB multiplexing daemon”) service. 
    # This daemon is in charge of multiplexing connections over USB to an iOS device. 
    # This is needed for transferring data from and to iOS devices (see ifuse). 
    # Also this may enable plug-n-play tethering for iPhones.
    usbmuxd.enable = lib.mkDefault false;

    # Whether to enable GNOME Keyring daemon, a service designed to take care of 
    # the user’s security credentials, such as user names and passwords.
    gnome.gnome-keyring.enable = lib.mkDefault true;
  };

  # 
  systemd.services.NetworkManager-wait-online.enable = lib.mkDefault false;

  #age.secrets.ts_auth.file = ../../secrets/ts_auth.age;

  # create a oneshot job to authenticate to Tailscale
  # systemd.services.tailscale-autoconnect = {
  #   description = "Automatic connection to Tailscale";

  #   # make sure tailscale is running before trying to connect to tailscale
  #   after = [ "network-pre.target" "tailscaled.service" ];
  #   wants = [ "network-pre.target" "tailscaled.service" ];
  #   wantedBy = [ "multi-user.target" ];

  #   # set this service as a oneshot job
  #   serviceConfig.Type = "oneshot";

  #   # have the job run this shell script
  #   script = with pkgs; ''
  #     # wait for tailscaled to settle
  #     sleep 2

  #     # check if we are already authenticated to tailscale
  #     status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
  #     if [ $status = "Running" ]; then # if so, then do nothing
  #       exit 0
  #     fi

  #     # otherwise authenticate with tailscale
  #     ${tailscale}/bin/tailscale up --authkey $(cat ${config.age.secrets.ts_auth.path})
  #   '';
  # };
  # systemd.services.crowdsec = with pkgs; {
  #   description = "Crowdsec agent";

  #   after = [ "syslog.target" "network.target" "remote-fs.target" "nss-lookup.target" ];
  #   wantedBy = [ "multi-user.target" ];

  #   serviceConfig.Type = "notify";

  #   serviceConfig = {
  #     ExecStartPre="${crowdsec}/bin/crowdsec -c /etc/crowdsec/config.yaml -t";
  #     ExecStart="${crowdsec}/bin/crowdsec -c /etc/crowdsec/config.yaml";
  #     ExecReload="${util-linux}/bin/kill -HUP $MAINPID";
  #   };
  # };
}

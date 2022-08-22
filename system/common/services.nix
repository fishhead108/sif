{ config, pkgs, lib, ... }: {
  
  services = {
    journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=7day
    '';
    
    # Enable a deamon that allows updating some devices
    # firmware, including UEFI for several machines
    fwupd.enable = true;

    # List of packages containing udev rules. All files found in pkg/etc/udev/rules.d and pkg/lib/udev/rules.d will be included.
    udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
    
    #### GEOCLUE
    # geoclue2.enable = true;

    # clight = {
    #   # Maybe causes freezes on sway + nvidia
    #   enable = true;
    #   temperature = {
    #     day = 5500;
    #     night = 2000;
    #   };
    # };

    # Enable programs to publish and discover services and
    # hosts running on a local network. For example, a user can
    # plug a computer into a network and have Avahi
    # automatically advertise the network services running on
    # its machine, facilitating user access to those services
    avahi = {
      enable = true;
      nssmdns = true;
    };

    fstrim.enable = true;

    # Windows share
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome3.gvfs;
    };

    # Smartcard support
    pcscd.enable = true;

    # ssh
    openssh = {
      enable = true;
      # kbdInteractiveAuthentication = false;
      # permitRootLogin = "no";
    };
    
    dbus.packages = with pkgs; [ dconf ];

    tailscale.enable = true;

    # Use the systemd-timesyncd SNTP client to sync the system clock (enabled by default)
    timesyncd.enable = true;

    # Thermals and cooling
    thermald.enable = true;

    usbmuxd.enable = true;

    # Enable keyring
    gnome.gnome-keyring.enable = true;
    
  };

}

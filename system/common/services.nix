{ config, pkgs, lib, ... }: 
{  
  services = {

    yubikey-agent.enable = false;

    localtimed.enable = false;

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
    geoclue2.enable = true;

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
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
      permitRootLogin = "no";
    };
    
    dbus.packages = with pkgs; [ dconf ];

    tailscale.enable = true;

    # Use the systemd-timesyncd SNTP client to sync the system clock (enabled by default)
    # timesyncd.enable = true;

    # Thermals and cooling
    thermald.enable = true;

    usbmuxd.enable = true;

    # Enable keyring
    gnome.gnome-keyring.enable = true;
  };

  # 
  systemd.services.NetworkManager-wait-online.enable = false;

  age.secrets.ts_auth.file = ../../secrets/ts_auth.age;

  # create a oneshot job to authenticate to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscaled.service" ];
    wants = [ "network-pre.target" "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up --authkey $(cat ${config.age.secrets.ts_auth.path})
    '';
  };
}

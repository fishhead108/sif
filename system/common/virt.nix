{ config, pkgs, lib, ... }:

{
  virtualisation = {
    # Allow unprivileged user to pass USB devices connected to
    # this machine to libvirt VMs, both local and remote
    spiceUSBRedirection.enable = true;

    # Install and configure Docker
    docker = {
      enable = true;
      # Run docker system prune -f periodically
      autoPrune.enable = true;
      autoPrune.dates = "weekly";
      # Don't start the service at boot, use systemd socket activation
      enableOnBoot = false;
    };

    # Install LXD
    lxd.enable = lib.mkDefault false;
    # Install VB
    virtualbox.host.enable = lib.mkDefault false;
    # Libvirtd (Qemu)
    libvirtd.enable = lib.mkDefault true;
  };
}

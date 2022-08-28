# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.overlays = [ (import ../../misc/packages) ];
  
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    plymouth = {
      enable = true;
      # https://sidhartharya.me/using-custom-plymouth-theme-on-nixos/
      # https://github.com/adi1090x/plymouth-themes
      themePackages = [ pkgs.adi1090x-plymouth ];
      theme = "dragon";
      extraConfig = "ShowDelay=3\n";
    };

    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  fileSystems."/nfs" =
    {
      mountPoint = "/nfs";
      device = "192.168.1.239:/volume1/fishhead";
      fsType = "nfs";
    };

  fileSystems."/french" =
    {
      mountPoint = "/french";
      device = "192.168.1.239:/volume1/French";
      fsType = "nfs";
    };

}
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
    
    loader = { 
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      # https://sidhartharya.me/using-custom-plymouth-theme-on-nixos/
      # https://github.com/adi1090x/plymouth-themes
      themePackages = [ pkgs.adi1090x-plymouth ];
      theme = "dragon";
      extraConfig = "ShowDelay=3\n";
    };

    kernelModules = [ "kvm-intel" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8607b90c-31da-48a6-850c-7c9dc8bd9229";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B0CA-5F5E";
      fsType = "vfat";
    };

}
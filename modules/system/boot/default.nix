{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.jd.boot;
in
{
  options.jd.boot = mkOption {
    description = "Type of boot. Default efi";
    default = null;
    type = types.enum [ "efi" ];
  };

  config = mkIf (cfg == "efi") {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        version = 2;
        extraEntries = ''
          menuentry "Reboot" {
            reboot
          }
          menuentry "Power off" {
            halt
          }
        '';
        extraConfig = if (config.jd.lenovo.enable) then "i915.enable_psr=0" else "";
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

    swapDevices = [];
  };
}

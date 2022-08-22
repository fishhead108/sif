# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_18;

    extraModulePackages = with pkgs; [
      linuxPackages_5_18.v4l2loopback 
      linuxPackages_5_18.acpi_call
    ];

    loader = { 
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    consoleLogLevel = 1;

    # Sysctl params
    kernel.sysctl = {
      # Allow VS Code to watch more files
      "fs.inotify.max_user_watches" = 524288;
      "vm.swappiness" = lib.mkDefault 1;
    };

    kernelModules = [ 
      "v4l2loopback" 
      "acpi_call" 
      "kvm-intel"
    ];

    kernelParams = [ 
      "quiet"
      "splash"
      "vga=current"
      "i915.fastboot=1"
      "loglevel=3"
      "udev.log_priority=3"
      "systemd.show_status=auto"
    ];

  };
  
  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
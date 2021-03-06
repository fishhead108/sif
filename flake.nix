{
  description = "Wil Taylor's system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    wks.url = "github:wiltaylor/nixwks";
    nixpkgs-overlay.url = "github:wiltaylor/nixpkgs-overlay";
    dev = {
      url = "github:wiltaylor/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
	    url = "github:wiltaylor/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, nixpkgs, home-manager, neovim-flake, wks, nixpkgs-overlay, dev, ... }:
  with builtins;
  let
    lib = import ./lib;

    allPkgs = lib.mkPkgs { 
      inherit nixpkgs; 
      cfg = { allowUnfree = true; };
      overlays = [
        #neovim-flake.overlay
        wks.overlay
        nixpkgs-overlay.overlay
        dev.overlay

        (self: last: {
          neovimWT = neovim-flake.packages."${self.system}".neovimWT; 
        })
      ];
    };

  in {
    devShell = lib.withDefaultSystems (sys: let
      pkgs = allPkgs."${sys}";
    in import ./shell.nix { inherit pkgs; });

    packages = lib.mkSearchablePackages allPkgs;

    nixosConfigurations = {
      dell = lib.mkNixOSConfig {
        name = "dell";
        system = "x86_64-linux";
        inherit nixpkgs allPkgs;
        cfg = let 
          pkgs = allPkgs.x86_64-linux;
        in {
          boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" "nvme" ];
          boot.kernelModules = [ "it87" "k10temp" "nct6775" "kvm-intel" ];
          sys.hotfix.kernelVectorWarning = true;

          networking.interfaces."enp59s0" = { useDHCP = true; };
          networking.networkmanager.enable = true;
          networking.useDHCP = false; 

          sys.desktop.kanshi.profiles = [];
          #   {
          #     "DP-1" = "position 0,0";
          #     "HDMI-A-1" = "position 3840,0";
          #     "DP-2" = "position 7680,0";
          #   }
          # ];

          sys.kernelPackage = pkgs.linuxPackages_5_16;
          sys.locale = "en_US.UTF-8";
          sys.timeZone = "Europe/Zurich";

          sys.users.primaryUser.name = "fishhead";
          sys.users.primaryUser.extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
          sys.virtualisation.vagrant.enable = true;
          sys.virtualisation.kvm.enable = true;
          sys.virtualisation.docker.enable = true;
          sys.virtualisation.appImage.enable = true;
          sys.virtualisation.virtualBox.enable = true;
          sys.cpu.type = "intel";
          sys.cpu.cores = 6;
          sys.cpu.threadsPerCore = 2;
          sys.cpu.sensorCommand = ''sensors | grep "pch_cannonlake-virtual" -A 3 | grep "temp1" | awk '{print $2}' '';
          sys.biosType = "efi";
          # sys.graphics.primaryGPU = "amd";
          # services.xserver.displayManager.defaultSession = "none+i3";
          sys.graphics.displayManager = "lightdm";
          sys.graphics.desktopProtocols = [ "xorg" ];
          sys.graphics.v4l2loopback = true;
          sys.graphics.gpuSensorCommand = ''sensors | grep "junction:" | awk '{print $2}' '';

          sys.audio.server = "pipewire";
          sys.hardware.g810led = false;
          sys.hardware.kindle = false;

          sys.security.yubikey = true;
          sys.security.username = "fishhead";
          sys.security.sshPublicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2u34uDlLjo6YfpgyvYTnhsUcmlANFdXEOo+jaM9R7DxNXjTVouMX06gwXvhtoKzbzqYf4OKBe+4xPA1rj/eBQenmCtzMLLCEy8JNDtx6KqdmrAZF9zlT71Y53Kl/EFFUDLEECcy6OmjkMDBLkxG6VhE3d3P39NbfXYa606dD0c6iGhZbj3iQK08Lz0Mt/S93/dQV6AfHtQDq0I/V5UwaA6vhpqFCkdqWWDxsew6IUxVXDFLLfb/ghYt4RND6c2xq2mqSwhZ9uVjUBdju0mZfgnQ616JkRGJANuE8BRUijp6LUswz1GYA7b0B7a0nKwk+VLoy6yYj8a+AX5XuREF70IeE2Kq85KmfRnumxMfAvLFDO0i9ACGyzmwFLP/tYyYyk9T4Ttdk8PM94BrlsHcFkZ3DcAtsx4H84KaWAsaZPVC+tBQFrTVS9HdJdi09L4N5+db4Cs1Fhwm69YXcSkQvNN61g3C5lYER7U7Wc4L7l1AlqxaEBdDURpGcpAjUvlRO+ZlTyUF/ZR3Qx24jMWtK3VkZdIkaV253v4TuZcDHwHub/9MnbUMydyTsp94n50WeKpAz/PHBHeB5KpE29DWNk8vmEQ134/t4S0hc6yL0vTGmlMLLOzqC0GNBBps+yamMI9xj6GVcic152+B2+mILRPC4LQu3u5nSCRaq2Qflh1Q==";

          sys.vfio.enable = false;
          sys.vfio.gpuType = "nvidia";
          sys.vfio.gpuPciIds = "10de:1e87,10de:10f8,10de:1ad8,10de:1ad9";
          sys.vfio.devIds = "0000:0c:00.0 0000:0c:00.1 0000:0c:00.2 0000:0c:00.3";
          sys.bluetooth = true;

        };
      };

      mini = lib.mkNixOSConfig {
        name = "mini";
        system = "x86_64-linux";
        inherit nixpkgs allPkgs;
        cfg = let 
          pkgs = allPkgs.x86_64-linux;
        in {
          boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];

          networking.interfaces."wlo1" = { useDHCP = true; };
          networking.wireless.interfaces = [ "wol1" ];
          networking.networkmanager.enable = true;
          networking.useDHCP = false; 

          sys.locale = "en_US.UTF-8";
          sys.timeZone = "Europe/Zurich";

          sys.users.primaryUser.extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" "wil" ];

          sys.kernelPackage = pkgs.linuxPackages_5_10;
          sys.graphics.displayManager = "gdm";
          sys.graphics.desktopProtocols = [ "xorg" "wayland" ];
          sys.cpu.type = "intel";
          sys.cpu.cores = 6;
          sys.cpu.threadsPerCore = 2;
          sys.cpu.sensorCommand = ''sensors | grep "pch_cannonlake-virtual" -A 3 | grep "temp1" | awk '{print $2}' '';
          sys.biosType = "efi";
          sys.graphics.primaryGPU = "intel";
          sys.audio.server = "pipewire";
          sys.virtualisation.docker.enable = true;
          sys.virtualisation.appImage.enable = true;

          sys.desktop.kanshi.profiles = [
            {
              "eDP-1" = "position 0,0";
            }
          ];


          sys.virtualisation.kvm.enable = true;
          sys.bluetooth = true;
          #sys.wifi = true;

          sys.security.yubikey = true;
          sys.security.username = "fishhead";
          sys.security.sshPublicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2u34uDlLjo6YfpgyvYTnhsUcmlANFdXEOo+jaM9R7DxNXjTVouMX06gwXvhtoKzbzqYf4OKBe+4xPA1rj/eBQenmCtzMLLCEy8JNDtx6KqdmrAZF9zlT71Y53Kl/EFFUDLEECcy6OmjkMDBLkxG6VhE3d3P39NbfXYa606dD0c6iGhZbj3iQK08Lz0Mt/S93/dQV6AfHtQDq0I/V5UwaA6vhpqFCkdqWWDxsew6IUxVXDFLLfb/ghYt4RND6c2xq2mqSwhZ9uVjUBdju0mZfgnQ616JkRGJANuE8BRUijp6LUswz1GYA7b0B7a0nKwk+VLoy6yYj8a+AX5XuREF70IeE2Kq85KmfRnumxMfAvLFDO0i9ACGyzmwFLP/tYyYyk9T4Ttdk8PM94BrlsHcFkZ3DcAtsx4H84KaWAsaZPVC+tBQFrTVS9HdJdi09L4N5+db4Cs1Fhwm69YXcSkQvNN61g3C5lYER7U7Wc4L7l1AlqxaEBdDURpGcpAjUvlRO+ZlTyUF/ZR3Qx24jMWtK3VkZdIkaV253v4TuZcDHwHub/9MnbUMydyTsp94n50WeKpAz/PHBHeB5KpE29DWNk8vmEQ134/t4S0hc6yL0vTGmlMLLOzqC0GNBBps+yamMI9xj6GVcic152+B2+mILRPC4LQu3u5nSCRaq2Qflh1Q==";
        };
      };
    };
  };
}

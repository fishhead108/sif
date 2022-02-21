{
  description = "System Config";
  
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
      url = "github:jordanisaacs/neovim-flake";
    };

    homeage = {
      url = "github:jordanisaacs/homeage/activatecheck";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    extra-container = {
      url = "github:erikarvstedt/extra-container";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { nixpkgs, home-manager, nur, neovim-flake, homeage, extra-container, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      util = import ./lib {
        inherit system pkgs home-manager lib overlays inputs;
      };

      scripts = import ./scripts {
        inherit pkgs lib;
      };

      inherit (import ./pkgs {
        inherit pkgs;
      }) myPkgs;

      inherit (import ./overlays {
        inherit system pkgs lib nur neovim-flake homeage scripts myPkgs extra-container;
      }) overlays;

      inherit (util) user;
      inherit (util) host;

      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          permittedInsecurePackages = [
            "electron-9.4.4"
          ];
          allowUnfree = true;
        };
      };

      system = "x86_64-linux";

      defaultConfig = {
        core.enable = true;
        boot = "efi";
        gnome = {
          enable = true;
          keyring = {
            enable = true;
          };
        };
        connectivity = {
          bluetooth.enable = true;
          sound.enable = true;
          printing.enable = true;
        };
        graphical = {
          xorg.enable = true;
          wayland = {
            enable = true;
            swaylock-pam = true;
          };
        };
        ssh.enable = true;
        extraContainer.enable = true;
      };

      dellConfig = defaultConfig // {
        dell = {
          enable = true;
        };
      };

      lenovoConfig = dellConfig // {
        lenovo = {
          enable = true;
          fprint = {
            enable = true;
          };
        };
      };

      defaultUser = [{
        name = "fishhead";
        groups = [ "wheel" "networkmanager" "video" ];
        uid = 1000;
        shell = pkgs.zsh;
        sshKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwSKMhCkWOzbKbM3sv2uepBW7hAwGCdG22vPxu3bYgn lenovo-09-12-2021"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyyuGULHQkJjH4kD6G0qcyzEu2g6AOm41Qk50EOxu0eVf2GCkJbhGHSXrJ3NxN5iaGNhWMon4iDbw4qKPcqmQg9urpPq6iaR/Vkt09P67oVwbcZI/MdAVI8X2atl+W10q71vnTRsIQEpZ3fNDT5vaWBEtJvM60L8ofzdQcczDGxyb/VWz0bkl6lwTIvWLxuINfWiBSjSD2orZhXtww+O+rbwZMwKiYeYVQzaXlhVxveHK3Fpu124pBU8M1wU+/tKXPxAoeHg8oFr6BvbNlXwMm8xR391f4/jA0giK+GIsn01LPfvON5nyNycsQDAjYwbjeLxHpg8m6FenlBmQQmDbDEiAXN9cY53PV7iEc9xQt8CFIxYhzzFZfEtQiokKMq9ZntgaP+WumB3w7yLS9dDGP1KjCd98TYn/GZg6crT5x0qwdQ8CabAoq6RJtRJVIZ/eAaPN1qlJh4ZrA83N55kEFqifae6cqGTXhGqEsII48ZEOGvl8jpy7YZJo3/Om3M9k= CM user"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVfCoUj2xE7VDaVSv/6MY9zKc/1aGN6/9mV5g4DtTazAuURuAXqhPBh/FEK3eCFQsp+pF7IG9hczct1AdO7bJvo38BTxnXp2b5dEw3/vfq2e+NavltT/iStgHgyx69iE1eT19VxSXEJeNsRziJuH6VsABnuSvaS2u+WDh6DdLevudLJuRZ2yyq9bM8vOtboLwvN933RZTdFJGrwwTJTojmbqL7vE/zS8oc6cMC5ubzWc03NRZHr/MQOtmCM5NKYs422E27OnKLoS0ZhPBrYwIIuvGFpoNghsIGq4ikG0dCe2KBKP485chAMdA7dNePclnxA2Bx5FMYEZvL4NJLOrO3wo3B902EYTK9i1L7NqxijasyQxp53xvynpCSyNU530Gtawr6x8JchWc/2R7A81Psu67o7697hlLpnUIyTil2uHc+mxv4aXBBhO4PtwS8In4mg4Z44NglzVPHYTLSJFbOAEvxq1LZUibgg4TBD4KMiIgzOGgTVJ88IaNKZB8EzimESWzd8aJTFCq/55VU154Io4iqyJdCMBJmAfCUpwWDQ5issSfUZpwi7rVLYDp0iY51aZnYh/PM1PpBlfghqZ0ZKEdvLf9deyynDidjCLj5pzR/ySxVgEEGLu4hLdkJLCXR2QMfkMpXSbkc0SzMQ3XeeN1XCu2HrUYxgO03Q2zZYw== cardno:10 127 999"
        ];
      }];

    in
    {
      installMedia = {
        kde = host.mkISO {
          name = "nixos";
          kernelPackage = pkgs.linuxPackages_latest;
          initrdMods = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "nvme" "usbhid" ];
          kernelMods = [ "kvm-intel" "kvm-amd" ];
          kernelParams = [ ];
          systemConfig = { };
        };
      };

      homeManagerConfigurations = {
        jd = user.mkHMUser {
          userConfig = {
            graphical = {
              applications = {
                enable = true;
                firefox.enable = true;
                libreoffice.enable = true;
              };
              wayland = {
                enable = true;
                type = "dwl";
                background.enable = true;
                statusbar.enable = true;
                screenlock.enable = true;
              };
              xorg = {
                enable = true;
                type = "dwm";
                screenlock.enable = true;
              };
            };
            applications.enable = true;
            gpg.enable = true;
            git.enable = true;
            zsh.enable = true;
            ssh.enable = true;
            direnv.enable = true;
            weechat.enable = true;
            office365 = {
              enable = true;
              onedriver.enable = true; # pkg currently broken
            };
            wine = {
              enable = false; # wine things currently broken
              office365 = false;
            };
            keybase.enable = true;
            pijul.enable = true;
          };
          username = "fishhead";
        };
      };

      nixosConfigurations = {
        dell = host.mkHost {
          name = "dell";
          NICs = [ "enp0s31f6" "wlp2s0" ];
          kernelPackage = pkgs.linuxPackages;
          initrdMods = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
          kernelMods = [ "kvm-intel" ];
          kernelParams = [ ];
          systemConfig = dellConfig;
          users = defaultUser;
          cpuCores = 12;
        };

        lenovo = host.mkHost {
          name = "lenovo";
          NICs = [ "wlp170s0" ];
          kernelPackage = pkgs.linuxPackages_latest;
          initrdMods = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
          kernelMods = [ "kvm-intel" ];
          kernelParams = [ ];
          systemConfig = lenovoConfig;
          users = defaultUser;
          cpuCores = 8;
          stateVersion = "21.11";
        };

        tower = host.mkHost {
          name = "desktop";
          NICs = [ "enp6s0" "wlp5s0" ];
          kernelPackage = pkgs.linuxPackages_latest;
          initrdMods = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
          kernelMods = [ "kvm-amd" ];
          kernelParams = [ ];
          systemConfig = defaultConfig;
          users = defaultUser;
          cpuCores = 12;
          stateVersion = "21.11";
        };
      };
    };
}

# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    # ./hyprland
    ./boot.nix
    ./environment.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./security.nix
    ./services.nix
  ];
}
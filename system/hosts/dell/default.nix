# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./services.nix
    ./nix.nix
  ];
}
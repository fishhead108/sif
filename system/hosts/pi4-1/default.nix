{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./services.nix
  ];
}
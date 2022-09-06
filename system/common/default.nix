# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./boot.nix
      ./fonts.nix
      ./hardware.nix
      ./locale.nix
      ./networking.nix
      ./nix.nix
      ./packages.nix
      ./security.nix
      ./services.nix
      ./u2f.nix
      ./users.nix
      ./virt.nix
    ];
}

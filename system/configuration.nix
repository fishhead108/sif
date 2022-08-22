# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./common/boot.nix
      ./common/fonts.nix
      ./common/hardware.nix
      ./common/locale.nix
      ./common/networking.nix
      ./common/nix.nix
      ./common/packages.nix
      ./common/security.nix
      ./common/services.nix
      ./common/u2f.nix
      ./common/users.nix
      ./common/virt.nix
    ];
}

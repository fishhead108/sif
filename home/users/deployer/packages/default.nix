{ config, pkgs, lib, ... }:
{
  imports = [
    ./packages.nix
    ./programs.nix
  ];
}

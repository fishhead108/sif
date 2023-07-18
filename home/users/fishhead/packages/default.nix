{ config, pkgs, lib, ... }: 

{
  imports = [
    ./packages.nix
    ./environment.nix
    ./programs.nix
  ];

}

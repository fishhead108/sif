{ config, pkgs, lib, ... }: 

{
  imports = [
    ./chatgpt.nix
    ./packages.nix
    ./environment.nix
    ./programs.nix
  ];

}

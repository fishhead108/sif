{ config, pkgs, lib, ... }:

{

  imports = [
    ./neovim
    ./ssh.nix
  ];
}
{ config, pkgs, lib, ... }:

{
  imports = [
    ./alacritty.nix
    ./battery_check.nix
    ./dunst.nix
    ./gpg.nix
    ./i3.nix
    ./keyring.nix
    ./locale.nix
    ./neovim
    ./picom.nix
    ./polybar.nix
    ./redshift.nix
    ./rofi.nix
    ./ssh.nix
    ./tmux.nix
    ./udiskie.nix
    ./vscode.nix
  ];
}
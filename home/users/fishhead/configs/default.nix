{ config, pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./battery_status.nix
    ./dunst.nix
    ./gpg.nix
    ./waybar.nix
    ./mako.nix
    ./fonts.nix
    ./i3.nix
    ./keyring.nix
    ./locale.nix
    ./neovim
    ./picom.nix
    ./polybar.nix
    ./redshift.nix
    ./rofi.nix
    #./spotify.nix
    ./ssh.nix
    ./tmux.nix
    ./udiskie.nix
    ./vscode.nix
    ./xdg.nix
  ];
}

{ config, pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./battery_status.nix
    ./dunst.nix
    ./fonts.nix
    ./git.nix
    ./waybar.nix
    ./mako.nix
    # ./gpg.nix
    ./i3.nix
    ./keyring.nix
    ./locale.nix
    ./mako.nix
    ./neovim
    ./picom.nix
    ./polybar.nix
    ./redshift.nix
    ./rofi.nix
    ./spotify.nix
    ./ssh.nix
    ./tmux.nix
    ./udiskie.nix
    ./vscode.nix
    #./waybar.nix
    ./xdg.nix
  ];
}

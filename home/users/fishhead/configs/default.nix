{ config, pkgs, lib, ... }:
{
  imports = [
    ./hyperland
    ./alacritty.nix
    # ./battery_status.nix
    # ./dunst.nix
    ./fonts.nix
    ./git.nix
    # ./gpg.nix
    # ./i3.nix
    ./keyring.nix
    ./locale.nix
    ./mako.nix
    ./neovim
    # ./picom.nix
    # ./polybar.nix
    # ./redshift.nix
    ./spotify.nix
    ./ssh.nix
    ./tmux.nix
    # ./udiskie.nix
    ./vscode.nix
    ./xdg.nix
  ];
}

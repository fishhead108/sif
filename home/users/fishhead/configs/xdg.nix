
{ config, pkgs, lib, ... }:

{
  xdg = {
    enable = true;
    mime.enable = true;
    systemDirs.data = ["$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share"];
    userDirs = {
      enable = true;
      createDirectories = false;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      publicShare = "/var/empty";
      templates = "/var/empty";
      videos = "$HOME/Videos";
    };
  };
}
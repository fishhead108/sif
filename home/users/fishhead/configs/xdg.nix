
{ config, pkgs, lib, ... }:

{
  xdg = {
    enable = true;
    mime.enable = true;
    systemDirs.data = [
      "$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share"
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    ];
    mimeApps.defaultApplications = {
      "x-scheme-handler/slack" = "slack.desktop";
    };
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
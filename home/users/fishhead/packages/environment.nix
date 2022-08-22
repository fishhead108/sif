{ config, pkgs, lib, ... }: 

{
  xdg.mime.enable = true;

  gtk = {
    enable = true;

    font = {
      package = pkgs.overpass;
      name = "Overpass Semi-Bold";
    };
    iconTheme = {
      name = "Numix";
    };
    theme = {
      name = "NumixSolarizedDarkOrange";
    };
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "Numix-Cursor";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "NumixSolarizedDarkOrange";
  };

  home.pointerCursor = {
    package = pkgs.numix-cursor-theme;
    name = "Numix-Cursor";
  };
}

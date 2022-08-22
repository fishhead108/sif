{ config, pkgs, lib, ... }:

{
  # create ~/.config/systemd/user/default.target.wants/redshift.service to enable
  services.redshift = {
    enable = true;
    settings.redshift = {
      brightness-day = "1";
      brightness-night = "1";
    };
    temperature = {
      day = 5000;
      night = 3000;
    };
    latitude = "46.544";
    longitude = "6.630";
    tray = true;
  };
}
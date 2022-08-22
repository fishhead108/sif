{ lib, ... }:

with lib;

{
    services.udiskie = {
        enable = mkDefault true;
        automount = true;
        notify = true;
        tray = "always";
    };
}
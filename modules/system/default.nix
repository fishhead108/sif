{ inputs }:
{ pkgs, config, lib, ... }:
{
  imports = [
    ./connectivity
    ./boot
    (import ./core { inherit inputs; })
    ./gnome
    ./dell
    ./lenovo
    ./graphical
    ./extra-container
    ./ssh
  ];
}

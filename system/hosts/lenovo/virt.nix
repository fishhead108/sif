{ config, pkgs, ... }:

{
  virtualisation = {
    waydroid.enable = false;
    lxd.enable = false;
    virtualbox = {
      host.enable = false;
      host.enableExtensionPack = true;
    };
  };
  users.extraGroups.vboxusers.members = [ "fishhead" ];
}
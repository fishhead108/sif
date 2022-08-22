{ system, config, pkgs, ... }:
{

  imports = [ 
    ./configs
    ./packages
  ];

  nixpkgs.overlays = [ (import ./overlays) ];

}

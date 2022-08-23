{ system, config, pkgs, ... }:
{

  imports = [ 
    ./configs
    ./packages
  ];
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nixpkgs.overlays = [ (import ./overlays) ];

}

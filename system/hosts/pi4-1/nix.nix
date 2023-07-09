{ config, pkgs, ... }: {
  # documentation = {};
  nix.extraOptions = ''
    trusted-users = [ "root" "nixos" ]
  '';
}

{ lib, inputs, system, ... }:

{
  dell = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/hosts/dell
      ../system/configuration.nix
    ];
  };

  lenovo = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ../system/hosts/lenovo
      ../system/configuration.nix
    ];
  };
}

{ lib, inputs, system, agenix, ... }:

{
  vm = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      agenix.nixosModules.age
      ../system/hosts/vm
      ../system/configuration.nix
    ];
  };

  dell = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      agenix.nixosModules.age
      ../system/hosts/dell
      ../system/configuration.nix
    ];
  };

  lenovo = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      agenix.nixosModules.age
      ../system/hosts/lenovo
      ../system/configuration.nix
    ];
  };
}

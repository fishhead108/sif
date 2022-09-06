{ lib, inputs, system, agenix, ... }:

{
  vm = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      agenix.nixosModules.age
      ../system/hosts/vm
      ../system/common
    ];
  };

  dell = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      agenix.nixosModules.age
      ../system/hosts/dell
      ../system/common
    ];
  };

  lenovo = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      agenix.nixosModules.age
      ../system/hosts/lenovo
      ../system/common
    ];
  };

  builder = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      agenix.nixosModules.age
      ../system/hosts/builder
      ../system/common
    ];
  };

}

{ lib, inputs, system, agenix, hyprland, ... }:

{
  # pi4-1 = lib.nixosSystem {
  #   system = "aarch64-linux";
  #   specialArgs = { inherit inputs; };
  #   modules = [
  #     agenix.nixosModules.age
  #     ../system/hosts/pi4-1
  #     ../system/common
  #   ];
  # };

  # pi4-2 = lib.nixosSystem {
  #   inherit system;
  #   specialArgs = { inherit inputs; };
  #   modules = [
  #     agenix.nixosModules.age
  #     ../system/hosts/pi4-2
  #     ../system/common
  #   ];
  # };

  # pi4-3 = lib.nixosSystem {
  #   inherit system;
  #   specialArgs = { inherit inputs; };
  #   modules = [
  #     agenix.nixosModules.age
  #     ../system/hosts/pi4-3
  #     ../system/common
  #   ];
  # };

  # pi4-4 = lib.nixosSystem {
  #   inherit system;
  #   specialArgs = { inherit inputs; };
  #   modules = [
  #     agenix.nixosModules.age
  #     ../system/hosts/pi4-4
  #     ../system/common
  #   ];
  # };

  # vm = lib.nixosSystem {
  #   inherit system;
  #   specialArgs = { inherit inputs; };
  #   modules = [
  #     agenix.nixosModules.age
  #     ../system/hosts/vm
  #     ../system/common
  #   ];
  # };

  dell = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      hyprland.nixosModules.default
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

  # builder = lib.nixosSystem {
  #   inherit system;
  #   specialArgs = { inherit inputs; };
  #   modules = [
  #     agenix.nixosModules.age
  #     ../system/hosts/builder
  #     ../system/common
  #   ];
  # };

}

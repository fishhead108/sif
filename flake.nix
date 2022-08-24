{
  description = "Home Manager (dotfiles) and NixOS configurations";

  inputs = {

    deploy-rs.url = "github:serokell/deploy-rs";

    nixpkgs.url = "nixpkgs/nixos-unstable";

    nurpkgs = {
      url = github:nix-community/NUR;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs @ { self, nixpkgs, nurpkgs, home-manager, deploy-rs }:
    let
      system = "x86_64-linux";
      # pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = (
        import ./outputs/nixos-conf.nix {
          inherit system;
          inherit (nixpkgs) lib inputs;
        }
      );

      homeConfigurations = (
        import ./outputs/home-conf.nix {
          inherit system nixpkgs nurpkgs home-manager;
        }
      );

      devShell.${system} = (
        import ./outputs/installation.nix {
          inherit system nixpkgs;
        }
      );

      deploy.nodes.dell = {
        
        hostname = "192.168.1.199";
        sshUser = "fishhead";
        profiles = {
          # system = {
          #   user = "root";
          #   path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations."dell";
          # };
          home = {
            user = "fishhead";
            profilePath = "/nix/var/nix/profiles/per-user/fishhead/home-manager";
            path = deploy-rs.lib.${system}.activate.home-manager self.homeConfigurations."fishhead";
          };
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}

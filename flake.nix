{
  description = "NixOS and user(Home Manager) configurations";

  inputs = {

    deploy-rs.url = "github:serokell/deploy-rs";

    nixpkgs.url = "nixpkgs/nixos-unstable";

    agenix = { 
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };

    nurpkgs = {
      url = github:nix-community/NUR;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs @ { self, nixpkgs, nurpkgs, home-manager, deploy-rs, agenix }:
    let
      system = "x86_64-linux";

      deploy = sshUser: sshHostName: homeUser: osConfigurationName: hmConfigurationName:  {
        hostname = sshHostName;
        sshUser = sshUser;
          profiles = {
            system = {
              user = "root";
              path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${osConfigurationName};
            };
            home = {
              user = homeUser;
              profilePath = "/nix/var/nix/profiles/per-user/${homeUser}/home-manager";
              path = deploy-rs.lib.${system}.activate.home-manager self.homeConfigurations.${hmConfigurationName};
            };
          };
      };
    in
    {
      nixosConfigurations = (
        import ./outputs/nixos-conf.nix {
          inherit (nixpkgs) lib;
          inherit system inputs agenix;
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

      deploy.nodes = {
        lenovo     = deploy "fishhead" "localhost" "fishhead" "lenovo" "fishhead-lenovo";
        dell       = deploy "fishhead" "192.168.1.199" "fishhead" "dell" "fishhead-dell";
        builder    = deploy "fishhead" "192.168.1.33" "deployer" "builder" "deployer";
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}

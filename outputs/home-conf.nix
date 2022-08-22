{ system, nixpkgs, home-manager, ... }:

let
  mkHome = username: (

    let
    homeDirectory = "/mnt/home/${username}";
    configHome = "${homeDirectory}/.config";

    pkgs = import nixpkgs {
        inherit system;
        # Allow unfree packages to be built and installed.
        config.allowUnfree = true;
        
        # Allow installing packages even if the system is unsupported and may not
        # work properly.
        config.allowUnsupportedSystem = true;
        
        config.xdg.configHome = configHome;
    };
    in
    home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs;

      modules = [
        {
          imports = [
            ../home/users/${username}/home.nix
          ];
          home = {
            inherit username homeDirectory;
            stateVersion = "22.05";
          };
        }
      ];
    }
  );
in
{
  fishhead = mkHome "fishhead";
}

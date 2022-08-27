{ pkgs, ... }:

{

  systemd.user.services.spotify_autologin = {
    Unit = {
      Description = "Automatic login to Spotify";
      After = "display-manager.service";
    };
    
    Service = {
      Type = "oneshot";
      ExecStart = "" + pkgs.writeScript "spotify_autologin" ''
        #!${pkgs.bash}/bin/bash --login
        if grep -Fxq 'autologin.canonical_username="fishhead108"' $HOME/.config/spotify/prefs; then 
          ${pkgs.spotify}/bin/spotify; 
        fi
        login() {
            "$@" &
            disown
            sleep 5
            pkill spotify
        }
        login ${pkgs.spotify}/bin/spotify --username=fishhead108 --password='${builtins.readFile ../../../../secrets/spotify_auth.token}'
      '';
    };
  };

}



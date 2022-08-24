{ pkgs, ... }:

{
  # create a oneshot job to authenticate to Tailscale
  systemd.user.services.spotify-autologin = {
    description = "Automatic login to Spotify";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    ExecStart = "if grep -Fxq 'autologin.canonical_username="fishhead108"' $HOME/.config/spotify/prefs; then exit 0; else ${spotify}/bin/spotify --user=fishhead108 --password='${builtins.readFile ../../../../secrets/spotify_auth.token}';fi"
  };
}



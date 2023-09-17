{ config, pkgs, ... }: {

  networking = {

    networkmanager.enable = true;

    useDHCP = false;
    
    nameservers = [ "1.1.1.1" "1.0.0.1" ];

    firewall = {
      # boolean or one of "strict", "loose"
      checkReversePath = "loose";
      allowPing = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      trustedInterfaces = [ "tailscale0" "lo" ];
    };

    extraHosts =
    ''
      192.168.1.239 torrent.home.arpa torrent
      192.168.1.239 calibre.home.arpa calibre
      192.168.1.239 vault.home.arpa   vault
      192.168.1.239 plex.home.arpa    plex
      192.168.1.239 code.home.arpa    code
      89.175.56.116 derp.infra.revizto.com derp
    '';

  };

}

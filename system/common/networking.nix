{ config, pkgs, ... }: {

  networking = {

    networkmanager.enable = true;

    useDHCP = false;
    
    nameservers = [ "1.1.1.1" "1.0.0.1" ];

    firewall = {
      allowPing = true;
      allowedTCPPorts = [ 22 443 3000 8080 25565 ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      trustedInterfaces = [ "tailscale0" ];
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

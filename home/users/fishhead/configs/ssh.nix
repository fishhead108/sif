# Configuration for the SSH client.
{ pkgs, ...}: {
  home.packages = with pkgs; [
    # Install SSH.
    openssh
  ];

  # Enable SSH's configuration.
  programs.ssh.enable = true;

  # Enable SSH compression.
  programs.ssh.compression = true;

  # Multiplex multiple sessions over a single connection when possible.
  programs.ssh.controlMaster = "auto";

  # The path to the control socket when multiplexing sessions.
  programs.ssh.controlPath = "~/.ssh/control-%r@%h:%p";

  # Keep control sockets open in the background for ten minutes.
  programs.ssh.controlPersist = "10m";

  # Hash hostnames and addresses when adding them to the known hosts file to
  # lessen information leaking.
  programs.ssh.hashKnownHosts = true;

  # Send a keepalive every 30 seconds.
  programs.ssh.serverAliveInterval = 30;

  programs.ssh.matchBlocks = {
    # "github.com" = {
    #   identitiesOnly = true;
    #   identityFile = "~/.ssh/github-auth";
    # };

    # "*.github.com" = {
    #   identitiesOnly = true;
    #   identityFile = "~/.ssh/github-auth";
    # };

    "*.revizto.com" = {
      user = "dmiroshnichenko";
    };

    "*.revizto-stage.com" = {
      user = "dmiroshnichenko";
    };

    "*.infra.revizto.com" = {
      user = "dmiroshnichenko";
    };

    "dell" = {
      hostname = "dell.home.arpa";
      user = "fishhead";
    };

    "lenovo" = {
      hostname = "lenovo.home.arpa";
      user = "fishhead";
    };

    "pi3" = {
      hostname = "192.168.1.151";
      user = "fishhead";
    };

    "pi4-1" = {
      hostname = "192.168.1.13";
      user = "fishhead";
    };

    "pi4-2" = {
      hostname = "192.168.1.119";
      user = "fishhead";
    };

    "pi4-3" = {
      hostname = "192.168.1.68";
      user = "fishhead";
    };

    "pi4-4" = {
      hostname = "192.168.1.220";
      user = "fishhead";
    };
  };
}
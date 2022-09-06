# Configuration for the SSH client.
{ pkgs, ...}: {
  home.packages = with pkgs; [
    # Install SSH.
    openssh
  ];

  programs.ssh = {
    # Enable SSH's configuration.
    enable = true;

    # Enable SSH compression.
    compression = true;

    # Multiplex multiple sessions over a single connection when possible.
    controlMaster = "auto";

    # The path to the control socket when multiplexing sessions.
    controlPath = "~/.ssh/control-%r@%h:%p";

    # Keep control sockets open in the background for ten minutes.
    controlPersist = "10m";

    # Hash hostnames and addresses when adding them to the known hosts file to
    # lessen information leaking.
    hashKnownHosts = true;

    # Send a keepalive every 30 seconds.
    serverAliveInterval = 30;
  };
}
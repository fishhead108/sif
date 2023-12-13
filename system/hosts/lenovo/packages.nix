{ pkgs, ... }:
#let
#  vscode = pkgs.vscode.overrideAttrs (oldAttrs: rec {
#    version = "1.82.2";
#    name = "vscode";
#  });
#in
{

  programs = {
    gnupg.agent.enable = false;
    noisetorch.enable = false;
  };
  environment.systemPackages = with pkgs; [
    # x2goclient
    guvcview # A simple interface for devices supported by the linux UVC driver
    #obs-studio              # 
    screenkey # A screencast tool to display your keys inspired by Screenflick
    zlib #
    # syncthing              # 
    # syncthingtray          # 
    _1password # 1Password command-line tool
    _1password-gui # Multi-platform password manager
    sniffnet # Cross-platform application to monitor your network traffic with ease
    opensnitch # An application firewall
    yubikey-agent
    obs-studio
#    vscode
  ];


}

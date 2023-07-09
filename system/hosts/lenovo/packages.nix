{ pkgs, ... }: {
  
  programs.noisetorch.enable = true;
  environment.systemPackages = with pkgs; [
      # x2goclient
      guvcview
      obs-studio
      screenkey
      zlib
      # syncthing
      # syncthingtray
  ];
}

{ pkgs, ... }: {
  
  programs.noisetorch.enable = true;
  systemPackages = with pkgs; [
      x2goclient
  ];
}

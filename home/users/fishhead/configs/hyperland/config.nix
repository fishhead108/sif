{ inputs, pkgs, ... }:
{
  imports = [ ./config.nix ];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      inputs.hycov.packages.${pkgs.system}.hycov
    ];
    systemdIntegration = true;
  };

  home.packages = with pkgs;[
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    # swaylock-effects
    swayidle
    pamixer
  ];

  

}
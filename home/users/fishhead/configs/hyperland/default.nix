{ pkgs, ... }:
{
  imports = [
    # ./gammastep.nix
    # ./kitty.nix
    ./mako.nix
    # ./swayidle.nix
    # ./swaylock.nix
    # ./wofi.nix
    ./zathura.nix
    ./hyperland.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    glib
    gnome3.adwaita-icon-theme
    gnome.nautilus
    grim
    grim
    hyprpaper
    imv
    kitty
    # mako
    mimeo
    pciutils
    swappy
    slurp
    hyprpicker
    swaybg
    swayidle
    swaylock
    # swaylock-effects
    # waybar
    wayland
    waypipe
    wdisplays
    wf-recorder
    wl-clipboard
    wl-mirror
    wlprop
    # wl-mirror-pick
    wlr-randr
    wofi
    ydotool
    xwaylandvideobridge
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };
}
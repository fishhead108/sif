{ pkgs, ... }:
{
  imports = [
    ./gammastep.nix
    # ./kitty.nix
    ./mako.nix
    # ./swayidle.nix
    # ./swaylock.nix
    # ./wofi.nix
    ./rofi.nix
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
    # wofi
    ydotool
    xwaylandvideobridge
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    LIBSEAT_BACKEND = "logind";
    QT_SCALE_FACTOR = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
  };
}
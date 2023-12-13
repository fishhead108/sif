{ config, pkgs, lib, hyprland, inputs, ... }:

let 
  dbus-hyprland-environment = pkgs.writeTextFile {
    name = "dbus-hyprland-environment";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;

    # systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    # systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
      systemctl --user stop xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

    configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gesettings/schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gesettings set $gnome_schema gtk-theme 'Adwaita'
        '';
    };

in
{

  imports = [
  #   ../../pkgs/kitty/pkg.nix
    # ./waybar.nix
  #   ../../pkgs/mako/pkg.nix
  ];

  environment.systemPackages = with pkgs; [
    dbus-hyprland-environment
    configure-gtk
    wayland
    glib
    gnome3.adwaita-icon-theme
    grim
    wl-clipboard
    bemenu
    wlr-randr
    gnome.nautilus
    pciutils
    waybar
    hyprpaper
    swaylock
    swayidle
    swaybg
    swaylock-effects
    wdisplays
    wofi
    playerctl
    mako
    kitty
    pipewire
  ];


# warning: xdg-desktop-portal 1.17 reworked how portal implementations are loaded, you
# should either set `xdg.portal.config` or `xdg.portal.configPackages`
# to specify which portal backend to use for the requested interface.

# https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in

# If you simply want to keep the behaviour in < 1.17, which uses the first
# portal implementation found in lexicographical order, use the following:

# xdg.portal.config.common.default = "*";

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ ];
  };

  security.pam.services.swaylock = { };

  programs.hyprland.enable = true;
  programs.xwayland.enable = true;

  environment.sessionVariables = rec {
   
    # Will break SDDM if running X11
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    GDK_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "fishhead";
      };
      default_session = initial_session;
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';

}
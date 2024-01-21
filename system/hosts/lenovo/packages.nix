{ pkgs, ... }:
#let
#  vscode = pkgs.vscode.overrideAttrs (oldAttrs: rec {
#    version = "1.82.2";
#    name = "vscode";
#  });
#in
let 
  dbus-hyprland-environment = pkgs.writeTextFile {
    name = "dbus-hyprland-environment";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;

    # systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    # systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland XDG_SESSION_TYPE=wayland
      systemctl --user stop xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
      systemctl --user start xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
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
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-wlr
    ];
    wlr = {
      enable = true;
      settings = { # uninteresting for this problem, for completeness only
        screencast = {
          output_name = "DP-2";
          max_fps = 30;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
  };

  programs = {
    gnupg.agent.enable = false;
    noisetorch.enable = false;
    hyprland.enable = true;
    xwayland.enable = true;
  };

  environment = {

    etc."greetd/environments".text = ''
      Hyprland
    '';
    
    sessionVariables = rec {
      # Will break SDDM if running X11
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      GDK_BACKEND = "wayland";
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
    
    systemPackages = with pkgs; [
      dbus-hyprland-environment
      # x2goclient
      # guvcview # A simple interface for devices supported by the linux UVC driver
      #obs-studio              # 
      # screenkey # A screencast tool to display your keys inspired by Screenflick
      # zlib #
      # syncthing              # 
      # syncthingtray          # 
      _1password # 1Password command-line tool
      _1password-gui-beta # Multi-platform password manager
      sniffnet # Cross-platform application to monitor your network traffic with ease
      # opensnitch # An application firewall
      yubikey-agent
      # obs-studio
  #    vscode
    ];
  };
}

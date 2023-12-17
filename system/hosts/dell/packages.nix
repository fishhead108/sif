{ pkgs, config, lib, ... }: 
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
  environment = {
    systemPackages = with pkgs; [
      # ack                                 # A grep-like tool tailored to working with large trees of source code
      # silver-searcher                     # A code-searching tool similar to ack, but faster
      # ripgrep                             # A utility that combines the usability of The Silver Searcher with the raw speed of grep
      # x2goserver
      # freerdp
      lightdm_gtk_greeter
      system-config-printer               # It uses IPP to configure a CUPS server
      acpi                                # Show battery status and other ACPI information
      smartmontools
      waybar
      _1password              # 1Password command-line tool
      _1password-gui          # Multi-platform password manager
      sniffnet                # Cross-platform application to monitor your network traffic with ease
      opensnitch              # An application firewall
      # wireplumber
      # pipecontrol
    ];
  };
}

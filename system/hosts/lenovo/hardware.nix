# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware = {
    # pulseaudio.enable = true;
    
    # Enable bluetooth
    bluetooth = {
      enable = true;

      # Enable all bluez plugins
      package = pkgs.bluez;

      powerOnBoot = true;

      # hsphfpd.enable = true;

      # Modern headsets will generally try to connect using the A2DP profile.
      # To enable this we need to add the following lines:
      settings = {
          General = {
              Enable = "Source,Sink,Media,Socket";
          };
      };
    };

    opengl = {
      # Enable OpenGL support in X11 systems, as well as for
      # Wayland compositors like sway and Weston
      enable = true;

      # Enable accelerated OpenGL rendering through the Direct
      # Rendering Interface (DRI)
      driSupport = true;

      # Support Direct Rendering for 32-bit applications (such
      # as Wine). This is currently only supported for the
      # nvidia and ati_unfree drivers, as well as Mesa
      driSupport32Bit = true;

      # Use Mesa OpenGL drivers
      # package = pkgs.mesa.drivers;

      # https://nixos.wiki/wiki/Intel_Graphics
      # https://nixos.wiki/wiki/Accelerated_Video_Playback
      extraPackages = with pkgs; [
        intel-gmmlib
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver
        # vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        intel-ocl
        libvdpau-va-gl
        vaapiVdpau
      ];
    };
  };

}
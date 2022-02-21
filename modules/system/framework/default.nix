{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.jd.lenovo;
in
{
  options.jd.lenovo = {
    enable = mkOption {
      description = "Enable lenovo options";
      type = types.bool;
      default = false;
    };

    fprint = {
      enable = mkOption {
        description = "Enable fingeprint";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    ({
      environment.defaultPackages = with pkgs; [ intel-gpu-tools ];
      hardware = {
        video.hidpi.enable = true;
        opengl = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver
            libvdpau-va-gl
          ];
        };
      };

      boot.kernelParams = [ "mem_sleep_default=deep" ];
      # See: https://01.org/linuxgraphics/downloads/firmware
      boot.extraModprobeConfig = ''
        options i915 enable_guc=3
        options i915 enable_fbc=1
      '';
    })
    (mkIf cfg.fprint.enable {
      services.fprintd.enable = true;
    })
  ]);
}

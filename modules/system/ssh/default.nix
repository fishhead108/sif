{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.jd.ssh;
in
{
  options.jd.ssh = {
    enable = mkOption {
      description = "Whether to enable dell settings. Also tags as dell for user settings";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs.ssh.startAgent = true;
  };
}

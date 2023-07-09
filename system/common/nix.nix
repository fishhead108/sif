{ config, pkgs, lib, ... }: {

  system.stateVersion = "23.05";

  nixpkgs.config.allowUnfree = true;

  nix = {

    # Enable automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      experimental-features    = [ "nix-command" ];
      trusted-users            = [ "@wheel" "deployer" ];
      auto-optimise-store      = true;
      builders-use-substitutes = true;
      keep-outputs             = true;
      keep-derivations         = true;
      connect-timeout          = 3;
      max-jobs                 = 6;
      min-free                 = "524288000";
      max-free                 = "5368709120";
    };
  };

  systemd = {
    services.clear-log = {
      description = "Clear >1 month-old logs every week";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=30d";
      };
    };
    timers.clear-log = {
      wantedBy = [ "timers.target" ];
      partOf = [ "clear-log.service" ];
      timerConfig.OnCalendar = "weekly UTC";
    };
  };

  location = {
    latitude = 46.512184;
    longitude = 6.626003;
  };

  documentation = lib.mkDefault {
    dev.enable = true;
    man.enable = true;
    info.enable = false;
  };

}

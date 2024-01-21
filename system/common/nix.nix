{ config, pkgs, lib, ... }: {

  system.stateVersion = "23.11";

  # nixpkgs.config = {
  #   allowUnfree = true;
  #   permittedInsecurePackages = [
  #     "electron-25.9.0"
  #   ];
  # };

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
    nixos.enable = false;
    dev.enable = false;
    man.enable = false;
    info.enable = false;
  };

}

{ pkgs, ... }: {

  system.stateVersion = "22.05";

  nixpkgs.config.allowUnfree = true;

  nix = {

    settings.auto-optimise-store = true;

    # Enable automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
    experimental-features = nix-command flakes

    keep-outputs = true
    keep-derivations      = true
    cores = 4
    connect-timeout = 3
    max-jobs = 6
    min-free = ${toString (500 * 1024 * 1024)}
    max-free = ${toString (5 * 1024 * 1024 * 1024)}
  '';
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
    latitude = 46.543934;
    longitude = 6.630556;
  };

  documentation = {
    dev.enable = true;
    man.enable = true;
    info.enable = false;
  };

}

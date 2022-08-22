{ pkgs, ...}:

{

  home.file.".config/systemd/user/battery_status.sh".source = ./battery_status/battery_status.sh;

  systemd.user.services.battery_status = {
    Unit = {
      Description = "Service: Send notification if battery is low";
      After = "display-manager.service";
    };
    
    Service = {
      Type = "oneshot";
      ExecStart = "%h/.config/systemd/user/battery_status.sh";
      Environment = ''"DISPLAY=:0"'';
    };
  };

  systemd.user.timers.battery_status = {
    Unit = {
      Description = "Timer: Send notification if battery is low";
      Requires= "battery_status.service";
    };

    Timer = {
      Unit = "battery_status.service";
      OnCalendar = "*:00/5";
    };

    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
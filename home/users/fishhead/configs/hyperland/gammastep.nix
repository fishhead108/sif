
{
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature = {
      day = 6000;
      night = 3600;
    };
    settings = {
      general.adjustment-method = "wayland";
    };
  };
}
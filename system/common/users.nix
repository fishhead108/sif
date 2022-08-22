{ pkgs, ... }: {

#  nix.settings.trusted-users = [ "root" "fishhead" "cm" "fish" ];
  nix.settings.trusted-users = [ "root" "fishhead" "deployer" ]; 
 # age.secrets.rootPassword.file = ./password.age;
  # users.users.root.passwordFile = config.age.secrets.rootPassword.path;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    fishhead = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "input" "video" "docker" "power" "networkmanager" "libvirtd" "plugdev" "i2c" ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
       "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVfCoUj2xE7VDaVSv/6MY9zKc/1aGN6/9mV5g4DtTazAuURuAXqhPBh/FEK3eCFQsp+pF7IG9hczct1AdO7bJvo38BTxnXp2b5dEw3/vfq2e+NavltT/iStgHgyx69iE1eT19VxSXEJeNsRziJuH6VsABnuSvaS2u+WDh6DdLevudLJuRZ2yyq9bM8vOtboLwvN933RZTdFJGrwwTJTojmbqL7vE/zS8oc6cMC5ubzWc03NRZHr/MQOtmCM5NKYs422E27OnKLoS0ZhPBrYwIIuvGFpoNghsIGq4ikG0dCe2KBKP485chAMdA7dNePclnxA2Bx5FMYEZvL4NJLOrO3wo3B902EYTK9i1L7NqxijasyQxp53xvynpCSyNU530Gtawr6x8JchWc/2R7A81Psu67o7697hlLpnUIyTil2uHc+mxv4aXBBhO4PtwS8In4mg4Z44NglzVPHYTLSJFbOAEvxq1LZUibgg4TBD4KMiIgzOGgTVJ88IaNKZB8EzimESWzd8aJTFCq/55VU154Io4iqyJdCMBJmAfCUpwWDQ5issSfUZpwi7rVLYDp0iY51aZnYh/PM1PpBlfghqZ0ZKEdvLf9deyynDidjCLj5pzR/ySxVgEEGLu4hLdkJLCXR2QMfkMpXSbkc0SzMQ3XeeN1XCu2HrUYxgO03Q2zZYw== cardno:10 127 999"
      ];
    };
    
    deployer = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "input" "video" "docker" "power" "networkmanager" "libvirtd" "plugdev" "i2c" ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVfCoUj2xE7VDaVSv/6MY9zKc/1aGN6/9mV5g4DtTazAuURuAXqhPBh/FEK3eCFQsp+pF7IG9hczct1AdO7bJvo38BTxnXp2b5dEw3/vfq2e+NavltT/iStgHgyx69iE1eT19VxSXEJeNsRziJuH6VsABnuSvaS2u+WDh6DdLevudLJuRZ2yyq9bM8vOtboLwvN933RZTdFJGrwwTJTojmbqL7vE/zS8oc6cMC5ubzWc03NRZHr/MQOtmCM5NKYs422E27OnKLoS0ZhPBrYwIIuvGFpoNghsIGq4ikG0dCe2KBKP485chAMdA7dNePclnxA2Bx5FMYEZvL4NJLOrO3wo3B902EYTK9i1L7NqxijasyQxp53xvynpCSyNU530Gtawr6x8JchWc/2R7A81Psu67o7697hlLpnUIyTil2uHc+mxv4aXBBhO4PtwS8In4mg4Z44NglzVPHYTLSJFbOAEvxq1LZUibgg4TBD4KMiIgzOGgTVJ88IaNKZB8EzimESWzd8aJTFCq/55VU154Io4iqyJdCMBJmAfCUpwWDQ5issSfUZpwi7rVLYDp0iY51aZnYh/PM1PpBlfghqZ0ZKEdvLf9deyynDidjCLj5pzR/ySxVgEEGLu4hLdkJLCXR2QMfkMpXSbkc0SzMQ3XeeN1XCu2HrUYxgO03Q2zZYw== cardno:10 127 999"
      ];
    };
  };

  security.sudo.extraRules = [
    {
      users = [ "fishhead" "deployer" ];
      commands = [
        {
          command = "${pkgs.ddcutil}/bin/ddcutil";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}

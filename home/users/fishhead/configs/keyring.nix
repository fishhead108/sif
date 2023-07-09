# Keyring and password settings for GUI settings.
{ config, pkgs, ...}:

let
  # The location of the seahorse askpass in the profile..
  askpass = "${config.home.profileDirectory}/libexec/seahorse/ssh-askpass";

  # The i3 modifier key.
  mod = config.xsession.windowManager.i3.config.modifier;

  # The current xinput location.
  xinput = "${config.home.profileDirectory}/bin/xinput";

  # The Yubikey input name.
  yubikeyInput = "Yubico YubiKey OTP+FIDO+CCID";
in
{
  home.packages = with pkgs; [
    # Ensure seahorse is available for both a GUI askpass, and managing
    # gnome-keyring.
    gnome.seahorse

    # Ensure xinput is available.
    xorg.xinput

    # The Yubikey manager and its GUI.
    yubikey-manager
    yubikey-manager-qt

    # The Yubikey personalization tool and its GUI.
    yubikey-personalization
    yubikey-personalization-gui

    # A tool to detect when your YubiKey is waiting for a touch
    yubikey-touch-detector

    # The Yubikey oath configuration program.
    # yubioath-desktop
    yubioath-flutter

    yubico-piv-tool
    pass
  ];

  systemd.user.sockets.yubikey-touch-detector = {
    Unit.Description = "Unix socket activation for YubiKey touch detector service";
    Socket = {
      ListenStream = "%t/yubikey-touch-detector.socket";
      RemoveOnStop = true;
    };
    Install.WantedBy = [ "sockets.target" ];
  };

  systemd.user.services.yubikey-touch-detector = {
    Unit = {
      Description = "Detects when your YubiKey is waiting for a touch";
      Requires = "yubikey-touch-detector.socket";
    };
    Service = {
      ExecStart = "${pkgs.yubikey-touch-detector}/bin/yubikey-touch-detector --libnotify";
      EnvironmentFile = "-%E/yubikey-touch-detector/service.conf";
    };
    Install = {
      Also = "yubikey-touch-detector.socket";
      WantedBy = [ "default.target" ];
    };
  };

  # The askpass to use for GUI ssh and sudo prompts.
  home.sessionVariables.SSH_ASKPASS = askpass;
  home.sessionVariables.SUDO_ASKPASS = askpass;

  # Extra commands to run when starting X11.
  xsession.initExtra = ''
    # Disable Yubikey input by default.
    # This doesn't prevent smarter programs from asking the Yubikey for a
    # token, then touching it to authorize, it only prevents the Yubikey from
    # emulating a keyboard to type a one time code every time it's bumped.
    # FIXME: This should probably cover more models or be host-specific.
    "${xinput}" disable '${yubikeyInput}'
  '';

  # i3 keybindings for the Yubikey.
  # xsession.windowManager.i3.config.keybindings = {
  #   # Disable yubikey input.
  #   "${mod}+Shift+y" = "exec ${xinput} disable '${yubikeyInput}'";

  #   # Enable yubikey input.
  #   "${mod}+Control+Shift+y" = "exec ${xinput} enable '${yubikeyInput}'";
  # };

}
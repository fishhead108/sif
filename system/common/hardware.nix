{ pkgs, lib, ... }: {

  # Whether to enable ALSA sound.
  sound.enable = true;

  # Enable sound.
  nixpkgs.config.pulseaudio = true;

  hardware = {
    ##### disable nvidia, very nice battery life.
    #nvidiaOptimus.disable = lib.mkDefault true;

    # High-resolution display
    video.hidpi.enable = true;

    # ddcutils requires i2c
    i2c.enable = true;

    # Whether to enable the PulseAudio sound server.
    pulseaudio = {
      enable = true;

      # 1. Only the full build has Bluetooth support
      # 2. Enable JACK support
      package = pkgs.pulseaudioFull; # .override { jackaudioSupport = true; };

      # For compatibility with 32-bit applications
      support32Bit = true;

      daemon.config = {
        flat-volumes = "no";
        resample-method = "speex-float-10";
      };
    };
    
    # Update the CPU microcode for Intel processors.
    cpu.intel.updateMicrocode = true;
  };
}
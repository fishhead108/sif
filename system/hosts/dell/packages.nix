{ pkgs, ... }: {
    systemPackages = with pkgs; [
      # ack                                 # A grep-like tool tailored to working with large trees of source code
      # silver-searcher                     # A code-searching tool similar to ack, but faster
      # ripgrep                             # A utility that combines the usability of The Silver Searcher with the raw speed of grep
      lightdm_gtk_greeter
      system-config-printer               # It uses IPP to configure a CUPS server
      acpi                                # Show battery status and other ACPI information
      smartmontools
      x2goserver
    ];
}

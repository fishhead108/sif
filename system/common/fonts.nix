{ pkgs, ... }: {

  fonts = {
    enableDefaultFonts = true; 
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts.fontconfig.allowType1 = true; # https://github.com/NixOS/nixpkgs/issues/59379
    fonts = with pkgs; [
      # The classic Microsoft fonts everyone uses.
      corefonts

      # The DejaVu fonts.
      dejavu_fonts

      # Various fontconfig utilities.
      fontconfig.bin

      # A font package for Japanese text.
      ipafont

      # A set of nice, open source fonts.
      league-of-moveable-type

      # A set of free fonts compatible with the classic Microsoft ones.
      liberation_ttf

      # A set of various monospaced fonts, patched with numerous extra unicode
      # glyphs for extra-shiny fonts in terminals, etc.
      nerdfonts

      # A set of nice fonts from Google.
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra

      # A set of monospaced fonts patched with extra glyphs.
      powerline-fonts
      source-code-pro
      ubuntu_font_family
      (nerdfonts.override { 
        fonts = [ 
          "FiraCode"
          "JetBrainsMono"
        ];
      })
    ];
  };
}
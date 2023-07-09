{ pkgs, lib, ... }: {

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      # A set of various monospaced fonts, patched with numerous extra unicode
      # glyphs for extra-shiny fonts in terminals, etc.
      font-manager
      nerdfonts

      # A set of monospaced fonts patched with extra glyphs.
      powerline-fonts
    ];
  };
}
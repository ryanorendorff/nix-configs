{ config, pkgs, ... }:

{
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts  # Micrsoft free fonts
      dejavu_fonts # DejaVu free fonts
      fira-code
      font-awesome-ttf
      hasklig
      inconsolata  # monospaced
      liberation_ttf
      # powerline-fonts
      terminus_font
      ttf_bitstream_vera
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
      vistafonts
      xorg.fontbh100dpi
      xorg.fontmiscmisc
      xorg.fontcursormisc
    ];
    fontconfig = {
      hinting.autohint = false;
      ultimate.enable = false;
      penultimate.enable = false;
      useEmbeddedBitmaps = true;
      defaultFonts.serif = [ "Liberation Serif" "Times New Roman" ];
      defaultFonts.sansSerif = [ "Liberation Sans" "Arial" "Ubuntu" ];
      defaultFonts.monospace = [ "DejaVu Sans Mono for Powerline" "Fira Code" "Ubuntu Mono" ]; 
    };
  };
}


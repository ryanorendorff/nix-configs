{ pkgs, lib ? pkgs.lib, vim ? pkgs.vim, ... }:

{
  # NixOS Auto-installs a program when called, temporarily
  NIX_AUTO_RUN = "1";
  # Background Color Fix for Mutt
  COLORFGBG = "default;default";
  # Unified Variables
  PAGER = "less";
  TERM = "xterm-256color";
  RTV_EDITOR = "vim";
  RTV_URLVIEWER = "${pkgs.urlview}/bin/urlview";
  # EDITOR = "${vim}/bin/vim"; // defined already in nix-darwin module
  BROWSER = "${pkgs.w3m}/bin/w3m";
}

{ pkgs, ... }:

rec {
  PROJECTS = "${builtins.getEnv "HOME"}/projects";
  dotfiles = "${PROJECTS}/nocoolnametom/dotfiles";
  ZILLOW = "${PROJECTS}/zillow";
  BROWSER = "${pkgs.w3m}/bin/w3m";
  EDITOR = "${pkgs.vim}/bin/vim";
  RTV_EDITOR = "${pkgs.vim}/bin/vim";
  RTV_URLVIEWER = "${pkgs.urlview}/bin/urlview";
}
{ pkgs, ... }:

rec {
  PROJECTS = "${builtins.getEnv "HOME"}/projects";
  dotfiles = "${PROJECTS}/nocoolnametom/dotfiles";
  ZILLOW = "${PROJECTS}/zillow";
  BROWSER = "${pkgs.w3m}/bin/w3m";
  EDITOR = "${nvim}/bin/nvim";
  RTV_EDITOR = "${nvim}/bin/nvim";
  RTV_URLVIEWER = "${pkgs.urlview}/bin/urlview";
}
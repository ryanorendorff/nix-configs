{ pkgs, config, ... }:

rec {
  PROJECTS = "${builtins.getEnv "HOME"}/projects";
  dotfiles = "${PROJECTS}/nocoolnametom/dotfiles";
  ZILLOW = "${PROJECTS}/zillow";
  BROWSER = "${pkgs.w3m}/bin/w3m";
  EDITOR = "${config.programs.vim.package}/bin/vim";
  RTV_EDITOR = "${config.programs.vim.package}/bin/vim";
  RTV_URLVIEWER = "${pkgs.urlview}/bin/urlview";
}

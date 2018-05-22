{ pkgs, ... }:

rec {
  PROJECTS = "${builtins.getEnv "HOME"}/Projects";
  dotfiles = "${builtins.getEnv "HOME"}/dotfiles";
  ZILLOW = "${PROJECTS}/zillow";
  BROWSER = "/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary";
  RTV_EDITOR = "${pkgs.vim}/bin/vim";
  RTV_URLVIEWER = "${pkgs.urlview}/bin/urlview";
}
{ pkgs, nvim, ... }:

rec {
  PROJECTS = "${builtins.getEnv "HOME"}/Projects";
  dotfiles = "${builtins.getEnv "HOME"}/dotfiles";
  ZILLOW = "${PROJECTS}/zillow";
  BROWSER = "/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary";
  EDITOR = "${nvim}/bin/nvim";
  RTV_EDITOR = "${nvim}/bin/nvim";
  RTV_URLVIEWER = "${pkgs.urlview}/bin/urlview";
}
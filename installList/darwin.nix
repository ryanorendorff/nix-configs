{ pkgs, sharedPythonPackages ? [], ... }:

let
  myPythonPackages = pythonPackages: with pythonPackages; [
  ] ++ sharedPythonPackages;
  php = pkgs.php72;
  phpPackages = pkgs.php72Packages;
in with pkgs; [
  (python.withPackages myPythonPackages)
  mine.chunkwm.border
  mine.chunkwm.core
  mine.chunkwm.ffm
  mine.chunkwm.purify
  mine.chunkwm.tiling
  skhd
  # rtv # can't currently be built on Darwin without `allowUnsupportedSystems = true` which causes problems with other packages
  # home-manager # can't currently be built on Darwin without `allowUnsupportedSystems = true` which causes problems with other packages
  mine.darwinApps.bitbar
  mine.darwinApps.firefox
  mine.darwinApps.google-play-music-desktop-player
  mine.darwinApps.iterm
  mine.darwinApps.postman
  mine.darwinApps.teensy
  mine.darwinApps.vscode
  mosh
  ripgrep
  shellcheck
  silver-searcher
]

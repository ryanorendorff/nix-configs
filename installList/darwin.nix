{ pkgs, ... }:

let
  myPythonPackages = pythonPackages: with pythonPackages; [
  ];
  php = pkgs.php72;
  phpPackages = pkgs.php72Packages;
in with pkgs; [
  (python.withPackages myPythonPackages)
  # mine.chunkwm.border
  # mine.chunkwm.core
  # mine.chunkwm.ffm
  # mine.chunkwm.purify
  # mine.chunkwm.tiling
  # skhd
  # rtv # can't currently be built on Darwin without `allowUnsupportedSystems = true` which causes problems with other packages
  # home-manager # can't currently be built on Darwin without `allowUnsupportedSystems = true` which causes problems with other packages
  mine.darwinApps.firefox
  mine.darwinApps.google-play-music-desktop-player
  mine.darwinApps.iterm
  mine.darwinApps.teensy
  mosh
  php
  phpPackages.composer
  ripgrep
  shellcheck
  silver-searcher
]
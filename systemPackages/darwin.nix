{ pkgs, chunkwm, mine, ... }:

let
  myPythonPackages = pythonPackages: with pythonPackages; [
  ];
  php = pkgs.php72;
  phpPackages = pkgs.php72Packages;
  firefox-bin = pkgs.callPackage ../applications/darwin/firefox-bin.nix {};
  iterm = pkgs.callPackage ../applications/darwin/iterm.nix {};
  teensy = pkgs.callPackage ../applications/darwin/teensy.nix {};
  google-play-music-desktop-player = pkgs.callPackage ../applications/darwin/google-play-music-desktop-player.nix {};
in
with pkgs; [
  (python.withPackages myPythonPackages)
  # chunkwm.border
  # chunkwm.core
  # chunkwm.ffm
  # chunkwm.purify
  # chunkwm.tiling
  # skhd
  # rtv # can't currently be built on Darwin without `allowUnsupportedSystems = true` which causes problems with other packages
  # home-manager # can't currently be built on Darwin without `allowUnsupportedSystems = true` which causes problems with other packages
  firefox-bin
  iterm
  teensy
  google-play-music-desktop-player
  php
  phpPackages.composer
  mosh
  ripgrep
  shellcheck
  silver-searcher
]

{ pkgs, chunkwm, ... }:

let
  myPythonPackages = pythonPackages: with pythonPackages; [
    websocket_client
  ];
  php = pkgs.php72;
  phpPackages = pkgs.php72Packages;
  firefox-bin = pkgs.callPackage ../applications/darwin/firefox-bin.nix {};
  iterm = pkgs.callPackage ../applications/darwin/iterm.nix {};
  teensy = pkgs.callPackage ../applications/darwin/teensy.nix {};
in
with pkgs; [
  (python.withPackages myPythonPackages)
  # chunkwm.border
  # chunkwm.core
  # chunkwm.ffm
  # chunkwm.purify
  # chunkwm.tiling
  # rtv # can't currently be built on Darwin without `allowUnsupportedSystems = true` which causes problems with others packages
  # skhd
  firefox-bin
  iterm
  teensy
  php
  phpPackages.composer
  mosh
  ripgrep
  shellcheck
  silver-searcher
  weechat # duplicated here because it depends on websocket_client but other python packages may need to be different between systems
]

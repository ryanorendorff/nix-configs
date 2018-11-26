{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, ... }:

import ../wpPlugin.nix {
  inherit pkgs stdenv;
  pluginName = "classic-editor";
  version = "0.5";
  sha256 = "1ikj8iy2yni9i2vanfd9zl7iqjjw3nna660v7kz68a7yrcc8gyxz";
}

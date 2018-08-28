{ pkgs, ...}:

with pkgs; with python36Packages;

callPackage ../../python-modules/pyyaml {  }

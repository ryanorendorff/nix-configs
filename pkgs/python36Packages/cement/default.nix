{ pkgs, ...}:

with pkgs; with python36Packages; with mine.python36Packages;

callPackage ../../python-modules/cement {  }

{ pkgs, ...}:

with pkgs; with python27Packages;

callPackage ../../python-modules/python-gitlab {  }

{ pkgs, ...}:

with pkgs; with python27Packages; with mine.python27Packages;

callPackage ../../python-modules/yamlordereddictloader {
  inherit pyyaml;
}

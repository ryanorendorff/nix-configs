{ pkgs, ... }:

with pkgs; with python36Packages;

callPackage ../../python-modules/fetchpypi {
  python = python3;
}

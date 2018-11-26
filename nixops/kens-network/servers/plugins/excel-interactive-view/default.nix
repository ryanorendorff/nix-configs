{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, ... }:

import ../wpPlugin.nix {
  inherit pkgs stdenv;
  pluginName = "excel-interactive-view";
  version = "0.4.1";
  sha256 = "0y6jfjizpza69mfzkgcpp5y1b04iqhwp3apw2kpaf85jq5vf7qn0";
}

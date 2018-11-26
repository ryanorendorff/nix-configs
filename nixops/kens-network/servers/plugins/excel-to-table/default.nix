{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, ... }:

import ../wpPlugin.nix {
  inherit pkgs stdenv;
  pluginName = "excel-to-table";
  sha256 = "18yj11s3rd6x9470aj3jj00k24qgdfxkdmpkflwhpd7cjpgf60xc";
}

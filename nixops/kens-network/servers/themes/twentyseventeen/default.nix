{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, ... }:

import ../wpTheme.nix {
  inherit pkgs stdenv;
  themeName = "twentyseventeen";
  version = "1.7";
  sha256 = "1pha6964q81w2jcl21c27wqs054amz0lzk8v0sl37d51yg0n7hai";
}

{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, ... }:

import ../wpPlugin.nix {
  inherit pkgs stdenv;
  pluginName = "youtube-embed-plus";
  version = "12.2";
  sha256 = "09vivnxz8d5hx4wad4li36diccmc870sg06a3ixhw8ai6yhvwrq3";
}

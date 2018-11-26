{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, ... }:

import ../wpPlugin.nix {
  inherit pkgs stdenv;
  pluginName = "simple-csv-table";
  sha256 = "0hm8rf6l83xkv82dmpcddpqjpzc7p9w3ahwiqyq0w764wzp7pfy1";
}

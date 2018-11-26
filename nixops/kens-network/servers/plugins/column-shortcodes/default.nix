{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, ... }:

import ../wpPlugin.nix {
  inherit pkgs stdenv;
  pluginName = "column-shortcodes";
  version = "1.0";
  sha256 = "1fy7hzyl3y25ilvapsgmp1q32pq35nmbma3f98ii7lrndi7nf9cn";
}

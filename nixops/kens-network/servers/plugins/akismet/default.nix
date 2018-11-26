{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, ... }:

import ../wpPlugin.nix {
  inherit pkgs stdenv;
  pluginName = "akismet";
  version = "4.1";
  sha256 = "0qqgm21lb6kqzjrxgkpc796fdmks4zj8wwzxz6dii2zlrz40fj0c";
}

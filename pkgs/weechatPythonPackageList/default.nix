{ pkgs, lib, ... }:

python: python.withPackages(ps: with ps; [
  websocket_client
  xmpppy
] ++ lib.optionals pkgs.stdenv.isDarwin [
  pkgs.mine.python2Packages.pync2
])
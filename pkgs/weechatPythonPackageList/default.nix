{ pkgs, ... }:

python: python.withPackages(ps: with ps; [
  websocket_client
  xmpppy
] ++ (if pkgs.stdenv.isDarwin then [
  pkgs.mine.python27Packages.pync
] else []))
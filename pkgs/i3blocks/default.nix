{ pkgs, config, ... }:

with pkgs;
{
  i3blocksContrib = callPackage ./i3blocksContrib { inherit config; };
  mine = callPackage ./mine { inherit config; };
}
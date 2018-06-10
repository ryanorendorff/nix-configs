{ pkgs, ... }:

{
  knownPlugins = pkgs.callPackage ./knownPlugins.nix {};
  vimConfig = pkgs.callPackage ./vimConfig.nix {};
}
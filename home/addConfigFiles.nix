{ pkgs, lib ? pkgs.lib, ... }:

myFiles: newFiles: lib.mkMerge([
  myFiles.xdg.rtv
  myFiles.xdg.wtfutil
] ++ newFiles)

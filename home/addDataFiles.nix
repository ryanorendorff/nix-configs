{ pkgs, lib ? pkgs.lib, ... }:

myFiles: newFiles: lib.mkMerge([] ++ newFiles)

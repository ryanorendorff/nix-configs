{ lib, pkgs, ... }:

[]
++ pkgs.callPackage ./personal {}
++ pkgs.callPackage ./work {}

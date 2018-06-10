{ lib, pkgs, ... }:

[]
++ pkgs.callPackage ./personal {}
++ pkgs.callPackage ./work {}
++ lib.optionals pkgs.stdenv.isDarwin ( pkgs.callPackage ./darwin.nix {} )
++ lib.optionals pkgs.stdenv.isLinux ( pkgs.callPackage ./linux.nix {} )
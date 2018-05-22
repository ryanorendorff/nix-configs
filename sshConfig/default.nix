{ lib, stdenv, pkgs, ... }:

[]
++ pkgs.callPackage ./personal {}
++ pkgs.callPackage ./work {}
++ lib.optionals stdenv.isDarwin ( pkgs.callPackage ./darwin.nix {} )
++ lib.optionals stdenv.isLinux ( pkgs.callPackage ./linux.nix {} )
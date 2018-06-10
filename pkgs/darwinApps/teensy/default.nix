{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Teensy";
  app = pkgs.callPackage ./app.nix { inherit mkDarwinApp; inherit appName; };
}
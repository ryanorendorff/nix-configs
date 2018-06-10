{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Google Play Music Desktop Player";
  app = pkgs.callPackage ./app.nix { inherit mkDarwinApp; inherit appName; };
}
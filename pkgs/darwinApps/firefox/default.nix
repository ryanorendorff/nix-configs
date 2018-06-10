{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Firefox";
  app = pkgs.callPackage ./app.nix { inherit mkDarwinApp; inherit appName; };
}
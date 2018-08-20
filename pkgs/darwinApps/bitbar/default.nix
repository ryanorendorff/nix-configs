{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Bitbar";
  app = pkgs.callPackage ./app.nix { inherit mkDarwinApp; inherit appName; };
}
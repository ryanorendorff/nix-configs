{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Postman";
  app = pkgs.callPackage ./app.nix { inherit mkDarwinApp; inherit appName; };
}
{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Visual Studio Code";
  app = pkgs.callPackage ./app.nix { inherit mkDarwinApp; inherit appName; };
}
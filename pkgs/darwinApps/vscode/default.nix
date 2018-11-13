{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Visual Studio Code";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp;
    inherit appName;
    inherit appMeta;
    version = "1.29.0";
    sha256  = "0qxz6j468nvgv4d8fibsi13q5ymc8z2gdx5kqcf6wixzrk0clnv8";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "A lightweight but powerful source code editor";
    homepage = https://code.visualstudio.com/;
    license = "mit";
  };
}

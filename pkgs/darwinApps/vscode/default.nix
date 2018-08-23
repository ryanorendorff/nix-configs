{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Visual Studio Code";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp;
    inherit appName;
    inherit appMeta;
    version = "1.26.1";
    sha256  = "0pnsfkh20mj7pzqw7wlfd98jqc6a1mnsq1iira15n7fafqgj8zpl";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "A lightweight but powerful source code editor";
    homepage = https://code.visualstudio.com/;
    license = "mit";
  };
}
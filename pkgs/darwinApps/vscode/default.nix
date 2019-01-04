{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Visual Studio Code";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp appName appMeta;
    version = "1.30.1";
    sha256  = "1f8grgav5capd2mm1nx0416na8c6qjh91680cfvf1jh4pjihs6g4";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "A lightweight but powerful source code editor";
    homepage = https://code.visualstudio.com/;
    license = "mit";
  };
}

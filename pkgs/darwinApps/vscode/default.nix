{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Visual Studio Code";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp;
    inherit appName;
    inherit appMeta;
    version = "1.28.2";
    sha256  = "0n7lavpylg1q89qa64z4z1v7pgmwb2kidc57cgpvjnhjg8idys33";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "A lightweight but powerful source code editor";
    homepage = https://code.visualstudio.com/;
    license = "mit";
  };
}
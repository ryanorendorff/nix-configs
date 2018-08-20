{ pkgs, mkDarwinApp, fetchurl, appName, ... }:

mkDarwinApp rec {
  inherit appName;
  version = "1.26.0";
  src = fetchurl {
    url = "https://vscode-update.azurewebsites.net/${version}/darwin/stable";
    sha256 = "1hzvgq0gkx1zlx7i77yqd7qip1a6dlmdgdrmvw5iykkfb5wddhh7";
    name = "${ builtins.replaceStrings [" "] ["_"]  appName }.zip";
  };

  buildPhase = false;
  installPhase = false;

  buildInputs = [ pkgs.undmg pkgs.unzip ];

  appMeta = with pkgs.stdenv.lib; {
    description = "A lightweight but powerful source code editor";
    homepage = https://code.visualstudio.com/;
    license = "mit";
  };
}


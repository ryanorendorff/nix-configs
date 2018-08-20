{ pkgs, mkDarwinApp, fetchurl, appName, ... }:

mkDarwinApp rec {
  inherit appName;
  version = "6.2.4";
  src = fetchurl {
    url = "https://dl.pstmn.io/download/latest/osx";
    sha256 = "051cn6whp5jm4rd9ywk8h279bb80fc9bql2dpy3ylkpzik3qbq4z";
    name = "${ builtins.replaceStrings [" "] ["_"]  appName }-osx-${version}.zip";
  };

  buildPhase = false;
  installPhase = false;

  buildInputs = [ pkgs.undmg pkgs.unzip ];

  appMeta = with pkgs.stdenv.lib; {
    description = "Postman Makes API Development Simple";
    homepage = https://www.getpostman.com/;
    license = {
      free = false;
      url = https://www.getpostman.com/licenses/postman_eula;
    };
  };
}

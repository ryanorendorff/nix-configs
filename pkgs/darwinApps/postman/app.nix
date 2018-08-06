{ pkgs, mkDarwinApp, fetchurl, ... }:

mkDarwinApp rec {
  appName = "Postman";
  version = "6.1.4";
  src = fetchurl {
    url = "https://dl.pstmn.io/download/latest/osx";
    sha256 = "0yi905v1mclpz5bcl9gs0bd89066303491267xx0141xdyb6ilq7";
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

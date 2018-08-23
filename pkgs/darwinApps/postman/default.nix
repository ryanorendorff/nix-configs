{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Postman";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp;
    inherit appName;
    inherit appMeta;
    version = "6.2.5";
    sha256  = "01aiiqgbqv8d819f6pnn73fswlrl26inb5af6pg6d9va08zg2xrm";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "Postman Makes API Development Simple";
    homepage = https://www.getpostman.com/;
    license = {
      free = false;
      url = https://www.getpostman.com/licenses/postman_eula;
    };
  };
}
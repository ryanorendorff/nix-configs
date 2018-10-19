{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Postman";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp;
    inherit appName;
    inherit appMeta;
    version = "6.4.4";
    sha256  = "1xkd48qnikfv2b85h1j6i09x0clspbmzi5nv6kq4gp7r5gz65753";
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
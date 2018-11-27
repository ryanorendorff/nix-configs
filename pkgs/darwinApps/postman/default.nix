{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Postman";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp appName appMeta;
    version = "6.5.2";
    sha256  = "0g4z5kr4gb93k82451klf8bdjsyiiax4na295khv79b3slc9vimw";
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

{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Postman";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp appName appMeta;
    version = "6.5.2";
    sha256  = "1f3mcya7d8d3bcny6phdkwrnhgc294myg9lhfyn6rcbz494w930p";
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

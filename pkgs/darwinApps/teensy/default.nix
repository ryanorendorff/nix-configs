{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Teensy";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp appName appMeta;
    version = "2018-06-09";
    sha256  = "02vljpvg60n99mvqw70aklljpdbbv7wxqlky2rq8k870lgmp8w8l";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "The Teensy Loader loads configurations for the Ergodox EZ";
    homepage = https://configure.ergodox-ez.com/;
    license = {
      free = false;
    };
  };
}
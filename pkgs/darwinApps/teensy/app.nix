{ pkgs, appName, mkDarwinApp, fetchurl, ... }:

mkDarwinApp rec {
  inherit appName;
  version = "2018-06-09";
  src = fetchurl {
    url = "https://s3.ca-central-1.amazonaws.com/ergodox-ez-configurator/executables/teensy.dmg";
    sha256 = "02vljpvg60n99mvqw70aklljpdbbv7wxqlky2rq8k870lgmp8w8l";
    name = "${ appName }.dmg";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "The Teensy Loader loads configurations for the Ergodox EZ";
    homepage = https://configure.ergodox-ez.com/;
    license = {
      free = false;
    };
  };
}
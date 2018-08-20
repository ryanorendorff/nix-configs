{ pkgs, mkDarwinApp, fetchurl, appName, ... }:

mkDarwinApp rec {
  inherit appName;
  version = "61.0.2";
  src = fetchurl {
    url =  "https://archive.mozilla.org/pub/firefox/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
    sha256 = "1ibdjf22pxklk2y9awxznxvi0386rbyayxh5vl2jd0rlmrczc8xz";
    name = "${ appName }.dmg";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "Mozilla Firefox, free web browser (binary package)";
    homepage = http://www.mozilla.org/firefox/;
    license = {
      free = false;
      url = http://www.mozilla.org/en-US/foundation/trademarks/policy/;
    };
  };
}


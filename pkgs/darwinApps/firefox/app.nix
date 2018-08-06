{ pkgs, mkDarwinApp, fetchurl, ... }:

mkDarwinApp rec {
  appName = "Firefox";
  version = "61.0.1";
  src = fetchurl {
    url =  "https://archive.mozilla.org/pub/firefox/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
    sha256 = "13sx6y6585dgvy4rrmcsilbvqblzn6fyi7nz1h3jbyh56ws4fbkc";
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


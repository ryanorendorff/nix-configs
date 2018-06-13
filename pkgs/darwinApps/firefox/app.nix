{ pkgs, mkDarwinApp, fetchurl, ... }:

mkDarwinApp rec {
  appName = "Firefox";
  version = "60.0.2";
  src = fetchurl {
    url =  "https://archive.mozilla.org/pub/firefox/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
    sha256 = "0cnp2ij4lh44lmyy1hjx0nrzcvd3nzmib723s7y0sf516lhwyaf2";
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


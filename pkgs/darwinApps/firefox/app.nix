{ pkgs, mkDarwinApp, fetchurl, ... }:

mkDarwinApp rec {
  appName = "Firefox";
  version = "58.0.2";
  src = fetchurl {
    url =  "https://archive.mozilla.org/pub/firefox/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
    sha256 = "0ivcid68wajhsb6siyd3bbycnh0dwnrzwys4iplj3p4a5a3aj2nk";
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


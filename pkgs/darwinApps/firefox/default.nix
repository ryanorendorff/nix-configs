{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Firefox";
  
  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp appName appMeta;
    version = "63.0.3";
    sha256  = "04c2sk84zn1wqmj4s5w2s446i7fb7p22r2bbahrjbbiv39yil81g";
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

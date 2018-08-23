{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Firefox";
  
  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp;
    inherit appName;
    inherit appMeta;
    version = "61.0.2";
    sha256  = "1ibdjf22pxklk2y9awxznxvi0386rbyayxh5vl2jd0rlmrczc8xz";
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
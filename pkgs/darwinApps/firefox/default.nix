{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Firefox";
  
  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp;
    inherit appName;
    inherit appMeta;
    version = "63.0.1";
    sha256  = "0ycgraigr9acbhbidnh5s9f9sy4qshhp36fhfjnb1wybklw11s3k";
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

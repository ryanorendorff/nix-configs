{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Bitbar";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp;
    inherit appName;
    inherit appMeta;
    version = "1.9.2";
    sha256  = "1r5fn6n63aax870wwwk8zrw9a6ziy874spmknarllm1z2ic7sccy";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "Put the output from any script or program in your Mac OS X Menu Bar";
    homepage = https://getbitbar.com/;
    license = "mit";
  };
}
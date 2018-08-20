{ pkgs, mkDarwinApp, fetchurl, appName, ... }:

mkDarwinApp rec {
  inherit appName;
  version = "1.9.2";
  src = fetchurl {
    url = "https://github.com/matryer/bitbar/releases/download/v${version}/BitBar-v${version}.zip";
    sha256 = "1r5fn6n63aax870wwwk8zrw9a6ziy874spmknarllm1z2ic7sccy";
    name = "${ builtins.replaceStrings [" "] ["_"]  appName }.zip";
  };

  buildPhase = false;
  installPhase = false;

  buildInputs = [ pkgs.undmg pkgs.unzip ];

  appMeta = with pkgs.stdenv.lib; {
    description = "Put the output from any script or program in your Mac OS X Menu Bar";
    homepage = https://getbitbar.com/;
    license = "mit";
  };
}

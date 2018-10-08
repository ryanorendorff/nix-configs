{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Bitbar";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp;
    inherit appName;
    inherit appMeta;
    version = "2.0.0-beta10";
    sha256  = "19ff401a4xbqc9n35marm3jl8wnaiklx97gilg1crwp0hrk1qwv9";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "Put the output from any script or program in your Mac OS X Menu Bar";
    homepage = https://getbitbar.com/;
    license = "mit";
  };
}
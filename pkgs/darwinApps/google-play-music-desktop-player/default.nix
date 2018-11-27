{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "Google Play Music Desktop Player";
  
  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp appName appMeta;
    version = "4.6.1";
    sha256  = "0bpsl61r498gznsyi1yr7nvxr4598kf0y7bcnf3vf0n3h57szfql";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "A beautiful cross platform Desktop Player for Google Play Music";
    homepage = https://www.googleplaymusicdesktopplayer.com/;
    license = "mit";
  };
}
{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "iTerm2";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp;
    inherit appName;
    inherit appMeta;
    version = "3.2.0";
    sha256  = "19121a3hdqvsm6l778s7myfm8z61ss8c0g8rlwlvypbfdybn4j3x";
  };

  appMeta = with pkgs.stdenv.lib; {
    description = "iTerm2 is a replacement for Terminal and the successor to iTerm";
    homepage = https://www.iterm2.com/;
    license = {
      free = true;
      url = https://www.iterm2.com/license.txt;
    };
  };
}
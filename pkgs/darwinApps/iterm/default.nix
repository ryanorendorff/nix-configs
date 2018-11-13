{ pkgs, darwinAppWrapper, mkDarwinApp, ... }:

darwinAppWrapper rec {
  appName = "iTerm2";

  app = pkgs.callPackage ./app.nix {
    inherit mkDarwinApp;
    inherit appName;
    inherit appMeta;
    version = "3.2.5";
    sha256  = "0s3jrwcwrkmb5ympr7vjc4jbgvkzgj2ripw1fzb6b1hzvq1yc7pc";
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

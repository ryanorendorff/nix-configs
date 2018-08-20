{ pkgs, lib ? pkgs.lib, stdenv ? pkgs.stdenv, debug ? false, ... }:

stdenv.mkDerivation rec {
  baseName = "slack-unread";
  category = "Messenger";
  version = "f9d7f33e1b3fb1dbc4c68485f1467fe68d5a2ed4";
  name = "bitbar-plugin-${baseName}-${version}";

  src = pkgs.fetchFromGitHub {
    rev = "${version}";
    sha256 = "1ii4fx30231221a661szls7jrbmi0l81cgyzcni8xfjsnx9sw8i1";
    owner = "matryer";
    repo = "bitbar-plugins";
  };

  buildInputs =  [(pkgs.python.withPackages(ps: with ps; [
    requests
  ]))];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cp $src/${category}/${baseName}* $out/
  '';
}
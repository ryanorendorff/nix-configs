{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  version = "2018-05-07";
  baseName = "nix-docker";
  name = "${baseName}-${version}";

  src = pkgs.fetchFromGitHub {
    rev = "5c0ca6669a63ba81dddd47c7d7884a23d2f82ccb";
    owner = "LnL7";
    repo = baseName;
    sha256 = "0gpy42a34jb55pl860l0ig91bgngj4g5b7dxxniyvvcvv0vjlr8h";
  };

  installPhase = ''
    mkdir -p $out
    cp -a * $out/
    chmod 0600 $out/ssh/insecure_rsa
  '';
}
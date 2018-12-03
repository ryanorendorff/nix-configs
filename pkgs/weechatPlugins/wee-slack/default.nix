{ pkgs, ... }:

with pkgs; stdenv.mkDerivation rec {
  version = "2.2.0";
  baseName = "wee-slack";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = baseName;
    repo = baseName;
    sha256 = "1iy70q630cgs7fvk2151fq9519dwxrlqq862sbrwypzr6na6yqpg";
  };

  buildInputs = [ weechat (mine.weechatPythonPackageList python) ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -a $src/* $out/
  '';
}

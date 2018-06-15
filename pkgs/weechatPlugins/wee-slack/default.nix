{ pkgs, ... }:

with pkgs; stdenv.mkDerivation rec {
  version = "2.0.0";
  baseName = "wee-slack";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = baseName;
    repo = baseName;
    sha256 = "0712zzscgylprnnpgy2vr35a5mdqhic8kag5v3skhd84awbvk1n5";
  };

  buildInputs = [ weechat (mine.weechatPythonPackageList python) ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -a $src/* $out/
  '';
}

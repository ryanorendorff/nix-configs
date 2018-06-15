{ pkgs, ... }:

with pkgs; stdenv.mkDerivation rec {
  version = "0.7";
  baseName = "weechat-notify-send";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "s3rvac";
    repo = baseName;
    sha256 = "1l10zbsl5p160mws25jczsivih12rnl18psfy8dmrxxzds3pml2g";
  };

  buildInputs = [ weechat (mine.weechatPythonPackageList python) ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -a $src/* $out/
  '';
}
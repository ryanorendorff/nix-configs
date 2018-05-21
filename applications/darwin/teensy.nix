{ stdenv, lib, fetchurl, undmg, ... }:

assert stdenv.isDarwin;

let
  appName = "Teensy";
in
stdenv.mkDerivation rec {
  name = "${lib.toLower appName}-darwin-${version}";
  version = "3.1.5";
  dlName = name;

  src = fetchurl {
    url = "https://s3.ca-central-1.amazonaws.com/ergodox-ez-configurator/executables/teensy.dmg";
    sha256 = "02vljpvg60n99mvqw70aklljpdbbv7wxqlky2rq8k870lgmp8w8l";
    name = "${ appName }.dmg";
  };

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${appName}.app"
    cp -R . "$out/Applications/${appName}.app"
  '';

  postInstall = ''
    ln -f $out/Applications/${appName}.app ~/Applications/${appName}.app
  '';

  meta = with stdenv.lib; {
    description = "The Teensy Loader loads configurations for the Ergodox EZ";
    homepage = https://configure.ergodox-ez.com/;
    license = {
      free = false;
    };
    platforms = platforms.darwin;
  };
}

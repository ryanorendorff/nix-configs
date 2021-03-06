{ pkgs, lib, ... }:

with pkgs;
with lib;

let
  version = "2018-12-05";
  baseName = "i3blocks-contrib";
  src = fetchFromGitHub {
    rev = "c6161379d4b5130f64a847026e7deadb1646bca8";
    sha256 = "10d9znrs2720kjsixvgbyijv4fyr04kcjpw8jxjpvhg3cp1fw9aq";
    owner = "vivien";
    repo = baseName;
  };
  mkI3blockContribScript = { scriptName, buildDeps ? []} : stdenv.mkDerivation rec {
    inherit version;
    inherit src;
    name = "${baseName}-${scriptName}-${version}";

    loc = "./${scriptName}";

    unpackPhase = ''
      cp -a $src/${scriptName} $loc
    '';

    buildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      patchShebangs $loc/*
    '';

    checkPhase = ''
      ${shellcheck}/bin/shellcheck -x $loc/${scriptName}
    '';

    installPhase = ''
      mkdir -p $out
      cp -a $loc/* $out/
      wrapProgram $out/${scriptName} --prefix PATH : ${lib.makeBinPath buildDeps}
    '';
  };
in mapAttrs' (name: type: {
  name = removeSuffix ".nix" name;
  value = let file = ./. + "/${name}"; in
  lib.callPackageWith (pkgs // {
    inherit mkI3blockContribScript;
    inherit debug;
    # passwords = import ../../../external/private/passwords/gen.nix;
  }) file {};
}) (filterAttrs (name: type:
  (type == "directory" && builtins.pathExists "${toString ./.}/${name}/default.nix") ||
  (type == "regular" && hasSuffix ".nix" name && ! (name == "default.nix"))
) (builtins.readDir ./.))

{ pkgs, lib, ... }:

with pkgs;
with lib;

let
  version = "2018-01-17";
  baseName = "i3blocks-contrib";
  src = fetchFromGitHub {
    rev = "13e46dc0f31dd5ed889025161a930db951011522";
    sha256 = "0bf0d6ijqmz0rld7ndh9r35iwjbcbkmddxk5lj609kw0si1srnzj";
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

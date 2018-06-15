{ pkgs, lib ? pkgs.lib, debug ? false, ... }:

with lib;

let
  pluginLangs = {
    guile = "guile";
    javascript = "javascript";
    lua = "lua";
    perl = "perl";
    python = "ruby";
    tcl = "tcl";
  };
  mkWeechatPluginFromMainGithub = {
      lang,
      baseName,
      inputs ? [],
      rev ? "1d9ca5457fcda5f90064362e505ab2231c5eca08",
      sha256 ? "0prpgjsnza5f1wzj4h9ikd56wvj01zh4l8r5i0li3faf8hvl9sxp"
    }: with pkgs; stdenv.mkDerivation rec {
    inherit baseName;
    version = rev;
    name = "${baseName}-${version}";

    src = fetchFromGitHub {
      inherit rev;
      inherit sha256;
      owner = "weechat";
      repo = "scripts";
    };

    buildInputs = [ weechat ] ++ inputs ++ (lib.optionals (lang == "python") [(pkgs.mine.weechatPythonPackageList pkgs.python)]);
    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out
      cp $src/${lang}/${baseName}* $out/
    '';
  };
in mapAttrs' (name: type: {
  name = removeSuffix ".nix" name;
  value = let file = ./. + "/${name}"; in
  lib.callPackageWith (pkgs // {
    inherit mkWeechatPluginFromMainGithub ;
    inherit debug;
    # passwords = import ../../../external/private/passwords/gen.nix;
  }) file {};
}) (filterAttrs (name: type:
  (type == "directory" && builtins.pathExists "${toString ./.}/${name}/default.nix") ||
  (type == "regular" && hasSuffix ".nix" name && ! (name == "default.nix"))
) (builtins.readDir ./.))
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
      rev ? "bceced8b2bd7ac42396d225b3cc304afc624dc11",
      sha256 ? "1k7ryx8z8xrngy5dmcmvdfqvx5cn0kclmz25khff3cink5wrqqqp"
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
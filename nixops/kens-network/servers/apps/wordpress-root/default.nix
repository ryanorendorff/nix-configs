{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib, wordpressConfig ? pkgs.hello, dbName ? "", dbUser ? "", uploadsDir ? "", saltsFile ? "", themes ? [ "kens-twentyten" ], plugins ? [ "akismet" ], ... }:

let
  wordpressConfig = pkgs.callPackage ./wordpress-config { inherit dbName dbUser saltsFile; };
  themePkgs = builtins.map (name: pkgs.callPackage (../../themes + "/${name}") {}) themes;
  pluginPkgs = builtins.map (name: pkgs.callPackage (../../plugins + "/${name}") {}) plugins;
in pkgs.stdenv.mkDerivation rec {
  name = "wordpress";
  src = pkgs.wordpress;
  installPhase = ''
    mkdir -p $out/public
    # copy all the wordpress files we downloaded
    cp -R * $out/public
    # symlink the wordpress config
    ln -s ${wordpressConfig} $out/wp-config.php
    # symlink uploads directory
    ln -s ${uploadsDir} $out/public/wp-content/uploads
    # remove bundled plugins(s) coming with wordpress
    rm -Rf $out/public/wp-content/plugins/*
    # remove bundled themes(s) coming with wordpress
    rm -Rf $out/public/wp-content/themes/*
    # remove index readme file which contains WP version
    rm -Rf $out/public/readme.html
    # remove useless wp-config-sample.php file
    rm -Rf $out/public/wp-config-sample.php
    # symlink additional theme(s)
    ${lib.concatMapStrings (theme: "ln -s ${theme} $out/public/wp-content/themes/${theme.themeName}\n") themePkgs}
    # symlink additional plugin(s)
    ${lib.concatMapStrings (plugin: "ln -s ${plugin} $out/public/wp-content/plugins/${plugin.pluginName}\n") pluginPkgs }
  '';
}

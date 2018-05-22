with import <nixpkgs> { };

let
  # These are packages set up to explicitly match what is available on Stage or Prod

  # PHP v5.5.37
  php55 = pkgs.lib.overrideDerivation pkgs.php56 (old: rec {
    version = "5.5.37";
    name = "php-${version}";
    src = fetchurl {
      url = "https://secure.php.net/distributions/php-${version}.tar.bz2";
      sha256 = "d2380ebe46caf17f2c4cd055867d00a82e6702dc5f62dc29ce864a5742905d88";
    };
    configureFlags = pkgs.php56.configureFlags ++ [
      "--with-config-file-scan-dir=/etc/php.d/php55"
    ];
  });

  # XDebug for PHP 5.5.37
  php55_xdebug = stdenv.mkDerivation rec {
    name = "xdebug-2.3.1";
    src = fetchurl {
      url = "http://pecl.php.net/get/${name}.tgz";
      sha256 = "0k567i6w7cw14m13s7ip0946pvy5ii16cjwjcinnviw9c24na0xm";
    };
    autoreconfPhase = "phpize";
    preConfigure = "touch unix.h";
    doCheck = true;
    checkTarget = "test";
    buildInputs = with pkgs; [ autoreconfHook php55 ];
    makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ];
  };

  # XCache for PHP 5.5.37 (this allows for symfony in-memory caching to occur)
  php55_xcache = stdenv.mkDerivation rec {
    name = "xcache-${version}";
    version = "3.2.0";
    src = fetchurl {
      url = "http://xcache.lighttpd.net/pub/Releases/${version}/${name}.tar.bz2";
      sha256 = "1gbcpw64da9ynjxv70jybwf9y88idm01kb16j87vfagpsp5s64kx";
    };
    autoreconfPhase = "phpize";
    preConfigure = "touch unix.h";
    doCheck = true;
    checkTarget = "test";
    configureFlags = [
      "--enable-xcache"
      "--enable-xcache-coverager"
      "--enable-xcache-optimizer"
      "--enable-xcache-assembler"
      "--enable-xcache-encoder"
      "--enable-xcache-decoder"
    ];
    buildInputs = with pkgs; [ autoreconfHook php55 m4 ];
    makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ];
  };

  # YAML for PHP 5.5.37
  php55_yaml = stdenv.mkDerivation rec {
    name = "yaml-1.3.1";
    src = fetchurl {
      url = "http://pecl.php.net/get/${name}.tgz";
      sha256 = "1fbmgsgnd6l0d4vbjaca0x9mrfgl99yix5yf0q0pfcqzfdg4bj8q";
    };
    configureFlags = [
      "--with-yaml=${pkgs.libyaml}"
    ];
    autoreconfPhase = "phpize";
    preConfigure = "touch unix.h";
    doCheck = true;
    checkTarget = "test";
    buildInputs = with pkgs; [ autoreconfHook php55 libyaml ];
    makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ];
  };

in

stdenv.mkDerivation rec {
  name = "zg-php55-env";

  # This is the list of packages used for this environment.
  buildInputs = with pkgs; [
    php55
    php55_xdebug
    php55_yaml
    php55_xcache
    makeWrapper
  ];

  # This sets up the environment within the shell, including a base PHP
  # config file at `.php/extensions.ini`, places the composer `bin`
  # directory within the path so you can run phpunit from the command line,
  # and symlinks the installed binaries to `.php/bin` so tehy can be used
  # in IDEs or however you may need them.
  shellHook = ''
    export PROJECT_HOME=`pwd`
    export PHP_INI_SCAN_DIR=$PROJECT_HOME/.php
    export PATH=$PROJECT_HOME/bin:$PATH
    mkdir -p .php
    if [ ! -s ".php/extensions.ini" ]; then
    cat > .php/extensions.ini <<EOL
      log_errors = 1
      error_log = $PROJECT_HOME/.php/php_errors.log
      date.timezone = America/Los_Angeles
      extension_dir = $out/lib/php/extensions
      zend_extension = ${php55_xdebug}/lib/php/extensions/xdebug.so
      xdebug.remote_enable = 1
      xdebug.remote_autostart = 1
      extension = ${php55_yaml}/lib/php/extensions/yaml.so
      extension = ${php55_xcache}/lib/php/extensions/xcache.so
    EOL
    fi
    if [ -L ".php/bin" ]; then
      rm .php/bin
    fi
    ln -s $env/bin .php/bin
  '';

  env = buildEnv {
    name = name;
    paths = buildInputs;
    buildInputs = [ makeWrapper ];
    postBuild = ''
      mkdir $out/bin.writable && cp --symbolic-link `readlink $out/bin`/* $out/bin.writable/ && rm $out/bin && mv $out/bin.writable $out/bin
      wrapProgram $out/bin/php --add-flags ""
    '';
  };

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln -s $env $out
  '';
}

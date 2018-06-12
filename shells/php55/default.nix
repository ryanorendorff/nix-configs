let
  # Set the variable "local_dir" to the project directory for the rest of the file.
  local_dir = builtins.toString ./.;
in with import <nixpkgs> {
  # Overwrite the PHP packages to load config from $PROJECT_ROOT/.php/config - requires compilation
  overlays = [
    (self: super: let
        applyLocalConfigDir = originalPackage: self.pkgs.lib.overrideDerivation originalPackage (old: rec {
          configureFlags = originalPackage.configureFlags ++ [
            "--with-config-file-scan-dir=${local_dir}/.php/config"
          ];
        }
      );
      in {
        php55 = self.lib.overrideDerivation super.php56 (old: rec {
          version = "5.5.37";
          name = "php-${version}";
          src = self.fetchurl {
            url = "https://secure.php.net/distributions/php-${version}.tar.bz2";
            sha256 = "d2380ebe46caf17f2c4cd055867d00a82e6702dc5f62dc29ce864a5742905d88";
          };
          configureFlags = super.php56.configureFlags ++ [
            "--with-config-file-scan-dir=${local_dir}/.php/config"
          ];
        });
        php55Packages = {
          composer = self.stdenv.mkDerivation rec {
            name = "composer-${version}";
            version = "1.6.3";
            src = self.fetchurl {
              url = "https://getcomposer.org/download/${version}/composer.phar";
              sha256 = "1dna9ng77nw002l7hq60b6vz0f1snmnsxj1l7cg4f877msxppjsj";
            };
            unpackPhase = ":";
            buildInputs = [ self.makeWrapper ];
            installPhase = ''
              mkdir -p $out/bin
              install -D $src $out/libexec/composer/composer.phar
              makeWrapper ${self.php55}/bin/php $out/bin/composer \
                --add-flags "$out/libexec/composer/composer.phar"
            '';
          };
          phpcs = self.stdenv.mkDerivation rec {
            name = "phpcs-${version}";
            version = "3.3.0";
            src = self.fetchurl {
              url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcs.phar";
              sha256 = "1zl35vcq8dmspsj7ww338h30ah75dg91j6a1dy8avkzw5zljqi4h";
            };
            phases = [ "installPhase" ];
            buildInputs = [ self.makeWrapper ];
            installPhase = ''
              mkdir -p $out/bin
              install -D $src $out/libexec/phpcs/phpcs.phar
              makeWrapper ${self.php55}/bin/php $out/bin/phpcs \
                --add-flags "$out/libexec/phpcs/phpcs.phar"
            '';
          };
          xdebug = self.stdenv.mkDerivation rec {
            name = "xdebug-2.3.1";
            src = self.fetchurl {
              url = "http://pecl.php.net/get/${name}.tgz";
              sha256 = "0k567i6w7cw14m13s7ip0946pvy5ii16cjwjcinnviw9c24na0xm";
            };
            autoreconfPhase = "phpize";
            preConfigure = "touch unix.h";
            doCheck = true;
            checkTarget = "test";
            buildInputs = with self; [ autoreconfHook php55 ];
            makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ];
          };
          xcache = self.stdenv.mkDerivation rec {
            name = "xcache-${version}";
            version = "3.2.0";
            src = self.fetchurl {
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
            buildInputs = with self; [ autoreconfHook php55 m4 ];
            makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ];
          };
          yaml = self.stdenv.mkDerivation rec {
            name = "yaml-1.3.1";
            src = self.fetchurl {
              url = "http://pecl.php.net/get/${name}.tgz";
              sha256 = "1fbmgsgnd6l0d4vbjaca0x9mrfgl99yix5yf0q0pfcqzfdg4bj8q";
            };
            configureFlags = [
              "--with-yaml=${self.libyaml}"
            ];
            autoreconfPhase = "phpize";
            preConfigure = "touch unix.h";
            doCheck = true;
            checkTarget = "test";
            buildInputs = with self; [ autoreconfHook php55 libyaml ];
            makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ];
          };
        };
        php56 = applyLocalConfigDir super.php56;
        php70 = applyLocalConfigDir super.php70;
        php71 = applyLocalConfigDir super.php71;
        php72 = applyLocalConfigDir super.php72;
    })
  ];
};

let
  packages = pkgs.php55Packages; # Alias the list of PHP packages to "packages"
  php = pkgs.php55; # Alias the PHP package to "php"

  # This is the config.ini for this project; it links the extensions required
  configIniFile = pkgs.writeText "env_config.ini" ''
    log_errors = 1
    error_log = ${local_dir}/.php/php_errors.log
    date.timezone = America/Los_Angeles
    extension_dir = ${local_dir}/.php/extensions
    extension = ${packages.xcache}/lib/php/extensions/xcache.so
    extension = ${packages.yaml}/lib/php/extensions/yaml.so
    zend_extension = ${packages.xdebug}/lib/php/extensions/xdebug.so
    xdebug.remote_enable = 1
    xdebug.remote_autostart = 1
  '';
in stdenv.mkDerivation rec {
  # This name isn't really very important, but can help identify the project this derivation file
  # belongs to.
  name = "zg-php55-env";

  # This is the list of packages used for this environment. If it's here then it's available within
  # the shell:
  buildInputs = with pkgs; [
    less
    packages.composer
    packages.phpcs
    php
  ];

  # This sets up the environment within the shell, places the composer `vendor/bin` directory within
  # the path so you can run phpunit from the command line, and symlinks the installed binaries to
  # `.php/bin` so they can be used in IDEs or however you may need them.
  shellHook = ''
    export PROJECT_HOME=`pwd`
    export PATH=$PROJECT_HOME/.php/bin:$PROJECT_HOME/vendor/bin:$PATH
    mkdir -p $PROJECT_HOME/.php/{extensions,config}
    rm -f $PROJECT_HOME/.php/bin && ln -s $env/bin $PROJECT_HOME/.php/bin
    rm -f $PROJECT_HOME/.php/config/env_config.ini && ln -s ${configIniFile} $PROJECT_HOME/.php/config/env_config.ini
  '';

  # This contains instructions to wrap the 
  env = buildEnv {
    name = name;
    paths = buildInputs;
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      mkdir $out/bin.writable && cp --symbolic-link `readlink $out/bin`/* $out/bin.writable/ > /dev/null 2>&1 && rm $out/bin && mv $out/bin.writable $out/bin
      wrapProgram $out/bin/php --add-flags ""
    '';
  };

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln -s $env $out
  '';
}

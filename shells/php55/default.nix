with import <nixpkgs> {
  # Overwrite the PHP packages to load config from $PROJECT_ROOT/.php/config - requires compilation
  overlays = [
    (self: super: {
        # This wraps an existing PHP executable with the configuration for this environment
        # This prevents us from having to compile the PHP package for each environment.
        wrapPhpWithConfig = phpPackage: configIni: self.stdenv.mkDerivation rec {
          name = "wrapped-php";
          phases = [ "installPhase" ];
          buildInputs = [ self.makeWrapper];
          installPhase = ''
            mkdir -p $out/bin
            ln -s ${phpPackage}/bin/php $out/bin/php
            wrapProgram $out/bin/php --add-flags "-c ${configIni}"
          '';
        };
        # This injects the wrapped executable into a given PHAR executable like composer, box, or phpcs
        injectPhpToPharPackage = pharPackage: packageName: phpPackage: self.lib.overrideDerivation pharPackage (old: rec {
          installPhase = ''
            mkdir -p $out/bin
            install -D $src $out/libexec/${packageName}/${packageName}.phar
            makeWrapper ${phpPackage}/bin/php $out/bin/${packageName} \
              --add-flags "-d memory_limit=-1 $out/libexec/${packageName}/${packageName}.phar"
          '';
        });
        php55 = self.lib.overrideDerivation super.php71 (old: rec {
          version = "5.5.37";
          name = "php-${version}";
          src = self.fetchurl {
            url = "https://secure.php.net/distributions/php-${version}.tar.bz2";
            sha256 = "d2380ebe46caf17f2c4cd055867d00a82e6702dc5f62dc29ce864a5742905d88";
          };
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
    })
  ];
};

let
  packages = pkgs.php55Packages; # Alias the list of PHP packages to "packages"
  php = pkgs.wrapPhpWithConfig pkgs.php55 configIniFile;

  # Ensure that composer is using the local environment's PHP executable
  composer = pkgs.injectPhpToPharPackage packages.composer "composer" php;

  # Ensure that phpcs is using the local environment's PHP executable
  phpcs = pkgs.injectPhpToPharPackage packages.phpcs "phpcs" php;

  # This is the config.ini for this project; it links the extensions required
  configIniFile = pkgs.writeText "env_config.ini" ''
    log_errors = 1
    error_log = ${builtins.toString ./.}/.php/php_errors.log
    date.timezone = America/Los_Angeles
    extension_dir = ${builtins.toString ./.}/.php/extensions
    extension = ${packages.xcache}/lib/php/extensions/xcache.so
    extension = ${packages.yaml}/lib/php/extensions/yaml.so
    zend_extension = ${packages.xdebug}/lib/php/extensions/xdebug.so
    xdebug.remote_enable = 1
    xdebug.remote_autostart = 1
  '';
in pkgs.mkShell rec {
  # This is the list of packages used for this environment. If it's here then it's available within
  # the shell:
  buildInputs = with pkgs; [
    less
    git
    composer
    phpcs
    php
  ];

  # This sets up the environment within the shell, places the composer `vendor/bin` directory within
  # the path so you can run phpunit from the command line, and symlinks the installed binaries to
  # `.php/bin` so they can be used in IDEs or however you may need them.
  shellHook = ''
    export PROJECT_HOME=`pwd`
    export PATH=$PROJECT_HOME/.php/bin:$PROJECT_HOME/vendor/bin:$PATH
    mkdir -p $PROJECT_HOME/.php/{extensions,config}
    [[ -e $PROJECT_HOME/.git/info/exclude && ! `grep "^\.php$" $PROJECT_HOME/.git/info/exclude` ]] && echo ".php" >> ./.git/info/exclude
    rm -f $PROJECT_HOME/.php/bin && ln -s $env/bin $PROJECT_HOME/.php/bin
  '';
}

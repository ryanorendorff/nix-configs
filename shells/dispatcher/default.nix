with import <nixpkgs> { };

let
  php-apcu = pkgs.php71Packages.apcu;
  php-ast = pkgs.php71Packages.ast;
  php-composer = pkgs.php71Packages.composer;
  php-igbinary = pkgs.php71Packages.igbinary;
  php-phpcs = pkgs.php71Packages.phpcs;
  php-redis = pkgs.php71Packages.redis;
  php-xdebug = pkgs.php71Packages.xdebug;
  php-yaml = pkgs.php71Packages.yaml;
in pkgs.stdenv.mkDerivation rec {
  name = "zg-dispatcher-env";

  # This is the list of packages used for this environment.
  buildInputs = with pkgs; [
    fasd
    makeWrapper
    php-apcu
    php-ast
    php-composer
    php-igbinary
    php-phpcs
    php-redis
    php-xdebug
    php-yaml
    php71
    redis
  ];

  # This sets up the environment within the shell, including a base PHP
  # config file at `.php/extensions.ini`, places the composer `bin`
  # directory within the path so you can run phpunit from the command line,
  # and symlinks the installed binaries to `.php/bin` so tehy can be used
  # in IDEs or however you may need them.
  shellHook = ''
    export PROJECT_HOME=`pwd`
    export PHP_INI_SCAN_DIR=$PROJECT_HOME/.php
    export PATH=$PROJECT_HOME/vendor/bin:$PATH
    mkdir -p .php
    if [ ! -s ".php/extensions.ini" ]; then
    cat > .php/extensions.ini <<EOL
      log_errors = 1
      error_log = $PROJECT_HOME/.php/php_errors.log
      date.timezone = America/Los_Angeles
      extension_dir = $out/lib/php/extensions
      extension = ${php-apcu}/lib/php/extensions/igbinary.so
      extension = ${php-ast}/lib/php/extensions/ast.so
      extension = ${php-igbinary}/lib/php/extensions/igbinary.so
      extension = ${php-redis}/lib/php/extensions/redis.so
      extension = ${php-yaml}/lib/php/extensions/yaml.so
      extension = ${php-yaml}/lib/php/extensions/yaml.so
      zend_extension = ${php-xdebug}/lib/php/extensions/xdebug.so
      xdebug.remote_enable = 1
      xdebug.remote_autostart = 1
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

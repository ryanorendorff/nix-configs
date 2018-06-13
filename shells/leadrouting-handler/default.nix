let
  # Set the variable "local_dir" to the project directory for the rest of the file.
  local_dir = builtins.toString ./.;
in with import <nixpkgs> {
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
        # This DOES force a recompilation, but extensions are far less time-intensive than recompiling PHP itself
        injectPhpToPharPackage = pharPackage: packageName: phpPackage: self.lib.overrideDerivation pharPackage (old: rec {
          installPhase = ''
            mkdir -p $out/bin
            install -D $src $out/libexec/${packageName}/${packageName}.phar
            makeWrapper ${phpPackage}/bin/php $out/bin/${packageName} \
              --add-flags "$out/libexec/${packageName}/${packageName}.phar"
          '';
        });
        elasticmq-server = self.stdenv.mkDerivation rec {
          name = "elasticmq-server-${version}";
          version = "0.13.11";

          src = self.fetchurl {
            url = "https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-${version}.jar";
            sha256 = "ce13dc295a77feaa3d279a298c9049237eb2b3b58cb51a315ad27506fb2c2d49";
          };

          unpackPhase = ":";

          buildInputs = [ self.jre self.makeWrapper ];

          installPhase = ''
            mkdir -p $out/{bin,lib}
            install -D $src $out/lib/elasticmq-server.jar
            makeWrapper ${self.jre}/bin/java $out/bin/elasticmq \
              --add-flags "-Dconfig.file=${local_dir}/config/app/dev/elasticmq.conf -jar $out/lib/elasticmq-server.jar"
          '';
        };
      }
    )
  ];
};

let
  packages = pkgs.php71Packages; # Alias the list of PHP packages to "packages"
  php = pkgs.wrapPhpWithConfig pkgs.php71 configIniFile;

  # Ensure that composer is using the local environment's PHP executable
  composer = pkgs.injectPhpToPharPackage packages.composer "composer" php;

  # Ensure that phpcs is using the local environment's PHP executable
  phpcs = pkgs.injectPhpToPharPackage packages.phpcs "phpcs" php;

  # Ensure that phpcs is using the local environment's PHP executable
  php-cs-fixer = pkgs.injectPhpToPharPackage packages.php-cs-fixer "php-cs-fixer" php;

  # This is the config.ini for this project; it links the extensions required
  configIniFile = pkgs.writeText "env_config.ini" ''
    log_errors = 1
    error_log = ${local_dir}/.php/php_errors.log
    date.timezone = America/Los_Angeles
    extension_dir = ${local_dir}/.php/extensions
    extension = ${packages.redis}/lib/php/extensions/redis.so
    extension = ${packages.memcached}/lib/php/extensions/memcached.so
    zend_extension = ${packages.xdebug}/lib/php/extensions/xdebug.so
    xdebug.remote_enable = 1
    xdebug.remote_autostart = 1
  '';
in stdenv.mkDerivation rec {
  # This name isn't really very important, but can help identify the project this derivation file
  # belongs to.
  name = "zg-dispatcher-env";

  # This is the list of packages used for this environment. If it's here then it's available within
  # the shell:
  buildInputs = with pkgs; [
    composer
    elasticmq-server
    git
    memcached
    php
    phpcs
    php-cs-fixer
    redis
  ];

  # This sets up the environment within the shell, places the composer `vendor/bin` directory within
  # the path so you can run phpunit from the command line, and symlinks the installed binaries to
  # `.php/bin` so they can be used in IDEs or however you may need them.
  shellHook = ''
    export PROJECT_HOME=`pwd`
    export PATH="$PROJECT_HOME/.php/bin":"$PROJECT_HOME/vendor/bin":"$PATH"
    mkdir -p "$PROJECT_HOME/.php/extensions"
    rm -f "$PROJECT_HOME/.php/bin" && ln -s $env/bin "$PROJECT_HOME/.php/bin"
    if [[ ! -e "$PROJECT_HOME/config/app/dev/elasticmq.conf" ]]; then
      mkdir -p "$PROJECT_HOME/config/app/dev" && \
        cp "$PROJECT_HOME/config/app/example/elasticmq.conf" "$PROJECT_HOME/config/app/dev/elasticmq.conf"
    fi
  '';

  # This contains instructions to wrap the redis-server with the typical dev port so we can just run
  # "redis-server" for running tests
  env = buildEnv {
    name = name;
    paths = buildInputs;
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      mkdir $out/bin.writable && cp --symbolic-link `readlink $out/bin`/* $out/bin.writable/ > /dev/null 2>&1 && \
        rm $out/bin && mv $out/bin.writable $out/bin
      wrapProgram $out/bin/redis-server --add-flags ""
    '';
  };

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln -s $env $out
  '';
}
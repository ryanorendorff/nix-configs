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
        });
      in {
        php56 = applyLocalConfigDir super.php56;
        php70 = applyLocalConfigDir super.php70;
        php71 = applyLocalConfigDir super.php71;
        php72 = applyLocalConfigDir super.php72;
    })
  ];
};

let
  packages = pkgs.php71Packages; # Alias the list of PHP packages to "packages"
  php = pkgs.php71; # Alias the PHP package to "php"

  # Ensure that composer is using the local environment's PHP executable
  composer = packages.composer;

  # Ensure that phpcs is using the local environment's PHP executable
  phpcs = pkgs.lib.overrideDerivation packages.phpcs (old: rec {
    installPhase = ''
      mkdir -p $out/bin
      install -D $src $out/libexec/phpcs/phpcs.phar
      makeWrapper ${php}/bin/php $out/bin/phpcs \
        --add-flags "$out/libexec/phpcs/phpcs.phar"
    '';
  });

  # This is the config.ini for this project; it links the extensions required
  configIniFile = pkgs.writeText "env_config.ini" ''
    log_errors = 1
    error_log = ${local_dir}/.php/php_errors.log
    date.timezone = America/Los_Angeles
    extension_dir = ${local_dir}/.php/extensions
    extension = ${packages.apcu}/lib/php/extensions/apcu.so
    extension = ${packages.ast}/lib/php/extensions/ast.so
    extension = ${packages.igbinary}/lib/php/extensions/igbinary.so
    extension = ${packages.redis}/lib/php/extensions/redis.so
    extension = ${packages.yaml}/lib/php/extensions/yaml.so
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
    less
    packages.composer
    packages.phpcs
    php
    redis
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
      wrapProgram $out/bin/redis-server --add-flags "--port 10010"
    '';
  };

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln -s $env $out
  '';
}

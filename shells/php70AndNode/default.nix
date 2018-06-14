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
        injectPhpToPharPackage = pharPackage: packageName: phpPackage: self.lib.overrideDerivation pharPackage (old: rec {
          installPhase = ''
            mkdir -p $out/bin
            install -D $src $out/libexec/${packageName}/${packageName}.phar
            makeWrapper ${phpPackage}/bin/php $out/bin/${packageName} \
              --add-flags "-d memory_limit=-1 $out/libexec/${packageName}/${packageName}.phar"
          '';
        });
    })
  ];
};

let
  packages = pkgs.php70Packages; # Alias the list of PHP packages to "packages"
  php = pkgs.wrapPhpWithConfig pkgs.php70 configIniFile;

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
    extension = ${packages.yaml}/lib/php/extensions/yaml.so
    zend_extension = ${packages.xdebug}/lib/php/extensions/xdebug.so
    xdebug.remote_enable = 1
    xdebug.remote_autostart = 1
  '';
in stdenv.mkDerivation rec {
  # This name isn't really very important, but can help identify the project this derivation file
  # belongs to.
  name = "zg-php70-and-node-env";

  # This is the list of packages used for this environment. If it's here then it's available within
  # the shell:
  buildInputs = with pkgs; [
    less
    git
    composer
    phpcs
    php-cs-fixer
    php
    nodejs
    npm2nix
  ];

  # This sets up the environment within the shell, places the composer `vendor/bin` directory within
  # the path so you can run phpunit from the command line, and symlinks the installed binaries to
  # `.php/bin` so they can be used in IDEs or however you may need them.
  shellHook = ''
    export PROJECT_HOME=`pwd`
    export PATH=$PROJECT_HOME/.php/bin:$PROJECT_HOME/vendor/bin:$PROJECT_HOME/node_modules/.bin:$PATH
    mkdir -p $PROJECT_HOME/.php/extensions
    rm -f $PROJECT_HOME/.php/bin && ln -s $env/bin $PROJECT_HOME/.php/bin
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

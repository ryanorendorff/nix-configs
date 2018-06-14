let
  # Set the variable "local_dir" to the project directory for the rest of the file.
  local_dir = builtins.toString ./.;
in with import <nixpkgs> { };

stdenv.mkDerivation rec {
  # This name isn't really very important, but can help identify the project this derivation file
  # belongs to.
  name = "zg-node-env";

  # This is the list of packages used for this environment. If it's here then it's available within
  # the shell:
  buildInputs = with pkgs; [
    less
    git
    nodejs
    npm2nix
  ];

  # This sets up the environment within the shell, places the composer `vendor/bin` directory within
  # the path so you can run phpunit from the command line, and symlinks the installed binaries to
  # `.php/bin` so they can be used in IDEs or however you may need them.
  shellHook = ''
    export PROJECT_HOME=`pwd`
    export PATH=$PROJECT_HOME/.node/bin:$PROJECT_HOME/node_modules/.bin:$PATH
    rm -f $PROJECT_HOME/.node/bin && ln -s $env/bin $PROJECT_HOME/.node/bin
  '';

  # This contains instructions to wrap the 
  env = buildEnv {
    name = name;
    paths = buildInputs;
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      mkdir $out/bin.writable && cp --symbolic-link `readlink $out/bin`/* $out/bin.writable/ > /dev/null 2>&1 && rm $out/bin && mv $out/bin.writable $out/bin
      wrapProgram $out/bin/node --add-flags ""
    '';
  };

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln -s $env $out
  '';
}

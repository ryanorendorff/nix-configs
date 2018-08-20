with import <nixpkgs> {};
let
  # Set the variable "local_dir" to the project directory for the rest of the file!
  local_dir = builtins.toString ./.;
  my_overlay = import (builtins.toString ../../pkgs/overlays.nix);
in with import <nixpkgs> { overlays = [ my_overlay ]; };

stdenv.mkDerivation rec {
  # This name isn't really very important, but can help identify the project this derivation file
  # belongs to.
  name = "zg-apops-env";

  # This is the list of packages used for this environment. If it's here then it's available within
  # the shell:
  buildInputs = with pkgs; [
    less
    git
    terraform_0_10-full
    ansible
    docker
    (python.withPackages (pythonPackages: with pythonPackages; [ pkgs.mine.python27Packages.apopscli ]))
  ];

  # This sets up the environment within the shell, places the composer `vendor/bin` directory within
  # the path so you can run phpunit from the command line, and symlinks the installed binaries to
  # `.php/bin` so they can be used in IDEs or however you may need them.
  shellHook = ''
    export PROJECT_HOME=`pwd`
    export PATH=$PROJECT_HOME/.bin:$PATH
    rm -f $PROJECT_HOME/.bin && ln -s $env/bin $PROJECT_HOME/.bin
  '';

  # This contains instructions to wrap the 
  env = buildEnv {
    name = name;
    paths = buildInputs;
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      mkdir $out/bin.writable && cp --symbolic-link `readlink $out/bin`/* $out/bin.writable/ > /dev/null 2>&1 && rm $out/bin && mv $out/bin.writable $out/bin
      wrapProgram $out/bin/terraform --add-flags ""
    '';
  };

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln -s $env $out
  '';
}

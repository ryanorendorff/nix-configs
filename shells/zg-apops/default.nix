with import <nixpkgs> { overlays = [ 
  (import (builtins.toString ../../pkgs/overlays.nix))
]; };

pkgs.mkShell rec {
  # This is the list of packages used for this environment. If it's here then it's available within
  # the shell:
  buildInputs = with pkgs; [
    less
    git
    terraform-full
    ansible
    docker
    (python.withPackages (pythonPackages: with pythonPackages; with pkgs.mine.python27Packages; [ apopscli boto3 pyasn1 ]))
  ];

  # This sets up the environment within the shell, places the composer `vendor/bin` directory within
  # the path so you can run phpunit from the command line, and symlinks the installed binaries to
  # `.php/bin` so they can be used in IDEs or however you may need them.
  shellHook = ''
    export PROJECT_HOME=`pwd`
    export PATH=$PROJECT_HOME/.bin:$PATH
    rm -f $PROJECT_HOME/.bin && ln -s $env/bin $PROJECT_HOME/.bin
    [[ -e $PROJECT_HOME/.git/info/exclude && ! `grep "^\.bin$" $PROJECT_HOME/.git/info/exclude` ]] && echo ".bin" >> ./.git/info/exclude
  '';
}

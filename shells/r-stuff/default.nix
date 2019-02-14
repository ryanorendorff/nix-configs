with import <nixpkgs> {};

let
  R-with-my-packages = rWrapper.override{ packages = with rPackages; [ imager purrr seriation ]; };
in pkgs.mkShell rec {
  # This is the list of packages used for this environment. If it's here then it's available within
  # the shell:
  buildInputs = with pkgs; [
    R-with-my-packages
  ];

  # This sets up the environment within the shell, places the composer `vendor/bin` directory within
  # the path so you can run phpunit from the command line, and symlinks the installed binaries to
  # `.php/bin` so they can be used in IDEs or however you may need them.
  shellHook = "";
}


Remember that, for now, nixops must be told _explicitly_ which system it will be building in if it's building on MacOS.

When Docker is active and the nix-docker container is installed try the following to ensure that you can build and deploy:

nix-build -E 'with import <nixpkgs> { system = "x86_64-linux"; }; hello.overrideAttrs (drv: { REBUILD = builtins.currentTime; })'

nixops deploy -d trivial --option system x86_64-linux


I am currently working on Ken's wordpress site using a vbox implementation.  The installation of WP seems to be going fine, but it's not being served correctly: some PHP pages are not executed or display PHP code, while others seem to work fine when accessed directly.
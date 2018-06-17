Remember that, for now, nixops must be told _explicitly_ which system it will be building in if it's building on MacOS.

When Docker is active and the nix-docker container is installed try the following to ensure that you can build and deploy:

nix-build -E 'with import  { system = "x86_64-linux"; }; hello.overrideAttrs (drv: { REBUILD = builtins.currentTime; })'

nixops deploy -d trivial --option system x86_64-linux
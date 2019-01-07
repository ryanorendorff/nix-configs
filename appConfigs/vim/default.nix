{ ... }:

{
  knownPlugins = import ./knownPlugins.nix {};
  vimConfig = import ./vimConfig.nix {};
}

{ pkgs, config, ... }:

with pkgs;

let
  appConfigs = pkgs.callPackage ../appConfigs { inherit config; };
in {
  etc-hosts = callPackage ./etc-hosts.nix { inherit config; };
  i3blocks = appConfigs.i3blocks;
  ideavimrc = callPackage ./ideavimrc.nix { inherit config; };
  mailcap = callPackage ./mailcap.nix { inherit config; };
  muttrc = callPackage ./muttrc.nix { inherit config; };
  npmrc = callPackage ./npmrc.nix { inherit config; };
  rtv-cfg = callPackage ./rtv-cfg.nix { inherit config; };
}
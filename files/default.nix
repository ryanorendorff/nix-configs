{ pkgs, config, ... }:

with pkgs;
{
  etc-hosts = callPackage ./etc-hosts.nix { inherit config; };
  ideavimrc = callPackage ./ideavimrc.nix { inherit config; };
  mailcap = callPackage ./mailcap.nix { inherit config; };
  muttrc = callPackage ./muttrc.nix { inherit config; };
  npmrc = callPackage ./npmrc.nix { inherit config; };
  rtv-cfg = callPackage ./rtv-cfg.nix { inherit config; };
}
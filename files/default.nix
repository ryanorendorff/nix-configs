{ callPackage, config, ... }:

{
  etc-hosts = callPackage ./etc-hosts.nix {};
  i3blocks = callPackage ../i3/i3blocks { config = config; };
  ideavimrc = callPackage ./ideavimrc.nix {};
  mailcap = callPackage ./mailcap.nix {};
  muttrc = callPackage ./muttrc.nix {};
  npmrc = callPackage ./npmrc.nix {};
  rtv-cfg = callPackage ./rtv-cfg.nix {};
}
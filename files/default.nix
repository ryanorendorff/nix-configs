{ callPackage, ... }:

{
  etc-hosts = callPackage ./etc-hosts.nix {};
  ideavimrc = callPackage ./ideavimrc.nix {};
  rtv-cfg = callPackage ./rtv-cfg.nix {};
  muttrc = callPackage ./muttrc.nix {};
}
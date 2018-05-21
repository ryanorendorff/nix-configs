{ callPackage, ... }:

{
  etc-hosts = callPackage ./etc-hosts.nix {};
}
{ pkgs, ... }:

{
  configuration = ''
    [gmusic]
    enabled = true
    username = nocoolnametom
    password = ${import ../../keys/private/google_mopidy_key.nix}
    bitrate = 320
    deviceid = 450C9A147151D4F5
    all_access = true
  '';
  extensionPackages = [
    pkgs.mopidy-gmusic
  ];
}

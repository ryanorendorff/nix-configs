{ pkgs, ... }:

{
  configuration = ''
    [gmusic]
    enabled = true
    username = nocoolnametom
    password = <google application password>
    bitrate = 320
    deviceid = 450C9A147151D4F5
  '';
  extensionPackages = [
    pkgs.mopidy-gmusic
  ];
}
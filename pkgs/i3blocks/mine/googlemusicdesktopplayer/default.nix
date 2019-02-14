{ pkgs, ... }:

pkgs.writeScript "googlemusicdesktopplayer" (
  let
    appPath = (if pkgs.stdenv.isDarwin then "/Library/Application Support" else "/.config") + "/Google Play Music Desktop Player/json_store/playback.json";
  in ''
    #!/usr/bin/env bash

    # <bitbar.title>Google Play Music Desktop Player</bitbar.title>
    # <bitbar.version>v1.0</bitbar.version>
    # <bitbar.author>Tom Doggett</bitbar.author>
    # <bitbar.author.github>nocoolnametom</bitbar.author.github>
    # <bitbar.desc>Displays current song.</bitbar.desc>
    # <bitbar.dependencies>bash, grep, sed</bitbar.dependencies>
    #

    ${pkgs.gnugrep}/bin/grep -q '"playing":\s*true' ${pkgs.my.directories.home}${builtins.replaceStrings [" "] ["\\ "]  appPath} &&
    ${pkgs.gnugrep}/bin/grep '\s*"title":\s*".*",' ${pkgs.my.directories.home}${builtins.replaceStrings [" "] ["\\ "]  appPath} |
    cut -d \" -f 4 ||
    echo "No Music"
  ''
)

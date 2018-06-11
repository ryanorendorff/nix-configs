{ pkgs, ... }:

let
  chromePersonalPath = "${pkgs.google-chrome}/bin/google-chrome-stable --profile-directory=\"Profile 1\"";
in pkgs.writeScript "youtube" ''
  #!/usr/bin/env bash
  ${chromePersonalPath} --app=https://www.youtube.com/embed/$1
''
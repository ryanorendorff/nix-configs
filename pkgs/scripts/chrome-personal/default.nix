{ pkgs, ... }:

let
  chromePersonalPath = "${pkgs.google-chrome}/bin/google-chrome-stable --profile-directory=\"Profile 1\"";
in pkgs.writeScript "chrome-personal" ''
  #!/usr/bin/env bash
  ${chromePersonalPath}
''
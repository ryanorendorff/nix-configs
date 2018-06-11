{ pkgs, ... }:

let
  chromePath = "${pkgs.google-chrome}/bin/google-chrome-stable --profile-directory=\"Default\"";
in pkgs.writeScript "chrome" ''
  #!/usr/bin/env bash
  ${chromePath}
''
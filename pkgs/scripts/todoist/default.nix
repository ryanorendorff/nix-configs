{ pkgs, ... }:

let
  chromePersonalPath = "${pkgs.google-chrome}/bin/google-chrome-stable --profile-directory=\"Profile 1\"";
in pkgs.writeScript "todoist" ''
  #!/usr/bin/env bash
  ${chromePersonalPath} --app=https://chrome.todoist.com/app?mini=2
''
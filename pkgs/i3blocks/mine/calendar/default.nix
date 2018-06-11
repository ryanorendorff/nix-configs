{pkgs, ...}:

pkgs.writeScript "calendar" ''
  #!/usr/bin/env bash

  # Get the next event from google calendar
  # Extracted from https://blog.hauck.io/get-your-google-calendar-into-tmux/
  #
  # version: 1.0.0
  # license: MIT

  ${pkgs.gcalcli}/bin/gcalcli --nostarted --noallday --nocolor --calendar "Calendar" --calendar "nocoolnametom@gmail.com" \
    agenda "'`date +%Y%m%dT00`'" "'`date +%Y%m%dT2359`'" \
  | cut -d " " -f 4- \
  | head -2 \
  | tail -1 \
  | sed "s/^ *//g" \
  | sed "s/    / /g" \
''
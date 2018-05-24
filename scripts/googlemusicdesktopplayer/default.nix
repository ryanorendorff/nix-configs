{...}:

let
  gplayAppInfo = "/mnt/vmware/tdoggett/Library/Application Support/Google Play Music Desktop Player/json_store/playback.json";
in ''
  #!/usr/bin/env bash

  # Get the next event from google calendar
  # Extracted from https://blog.hauck.io/get-your-google-calendar-into-tmux/
  #
  # version: 1.0.0
  # license: MIT

  grep -q '"playing":\s*true' "${gplayAppInfo}" && grep '\s*"title":\s*".*",' "${gplayAppInfo}" | cut -d \" -f 4 || echo "Not Playing..."
''

{pkgs, ...}:

let
  chunkc = "${pkgs.mine.chunkwm.core}/bin/chunkc";
in pkgs.writeScript "chunkwm_skhd" ''
  #!/bin/bash

  # <bitbar.title>chunkwm/skhd helper</bitbar.title>
  # <bitbar.version>v1.1</bitbar.version>
  # <bitbar.author>Tom Doggett</bitbar.author>
  # <bitbar.author.github>nocoolnametom</bitbar.author.github>
  # <bitbar.desc>Plugin that displays desktop id and desktop mode of chunkwm, based on original by Shi Han NG (shihanng).</bitbar.desc>
  # <bitbar.dependencies>chunkwm,skhd</bitbar.dependencies>

  # Info about chunkwm, see: https://github.com/koekeishiya/chunkwm
  # For skhd, see: https://github.com/koekeishiya/skhd

  if [[ "$1" = "stop" ]]; then
    launchctl stop org.nixos.chunkwm
    launchctl stop org.nixos.skhd
  fi

  if [[ "$1" = "start" ]]; then
    launchctl start org.nixos.chunkwm
    launchctl start org.nixos.skhd
  fi

  echo "$(${chunkc} tiling::query --desktop id):$(${chunkc} tiling::query --desktop mode) | length=5"
  echo "---"
  echo "Start chunkwm & skhd | bash='$0' param1=start terminal=false"
  echo "Stop chunkwm & skhd | bash='$0' param1=stop terminal=false"
''
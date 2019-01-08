{ pkgs,...}:

pkgs.writeScript "pomodoro" ''
  #!/usr/bin/env bash
  echo "💩$(${pkgs.mine.python3Packages.i3-gnome-pomodoro}/bin/pomodoro-client status | sed 's/Pomodoro//')"
  if [ -n "$BLOCK_BUTTON" ]; then 
    ${pkgs.mine.python3Packages.i3-gnome-pomodoro}/bin/pomodoro-client toggle
  fi
''
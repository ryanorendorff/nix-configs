{ pkgs,...}:

pkgs.writeScript "pomodoro" ''
  #!/usr/bin/env bash
  echo "💩 $(${pkgs.mine.python36Packages.i3-gnome-pomodoro}/bin/pomodoro-client status)"
  if [ -n "$BLOCK_BUTTON" ]; then 
    ${pkgs.mine.python36Packages.i3-gnome-pomodoro}/bin/pomodoro-client toggle
  fi
''
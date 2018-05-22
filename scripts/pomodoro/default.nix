{mine,...}:

''
  #!/usr/bin/env bash
  echo "💩 $(${mine.i3-gnome-pomodoro-mine}/bin/pomodoro-client status)"
  if [ -n "$BLOCK_BUTTON" ]; then 
    ${mine.i3-gnome-pomodoro-mine}/bin/pomodoro-client toggle
  fi
''
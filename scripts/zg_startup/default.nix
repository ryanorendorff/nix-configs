{ zgitclone, pkgs, ...}:

''
  #!/usr/bin/env bash

  # Remove listing of current zillow git repos
  if [ -e ${builtins.getEnv "HOME"}/.local/share/zillowgits ]; then
    rm ${builtins.getEnv "HOME"}/.local/share/zillowgits
  fi

  npm set progress false;
''
+ ( pkgs.callPackage ./buildProjectList.nix {
  zgitclone = zgitclone;
  projectList = import ../../workProjectList;
} )
+ ''
  npm set progress true"
''
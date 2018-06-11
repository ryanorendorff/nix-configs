{ pkgs, lib, ...}:

pkgs.writeScript "zg_startup" (
  ''
    #!/usr/bin/env bash

    # Remove listing of current zillow git repos
    if [ -e ${builtins.getEnv "HOME"}/.local/share/zillowgits ]; then
      rm ${builtins.getEnv "HOME"}/.local/share/zillowgits
    fi

    npm set progress false;
  ''
  + ( import ./buildProjectList.nix {
    inherit lib;
    inherit pkgs;
    projectList = import ../../../workProjectList;
  } )
  + ''
    npm set progress true"
  ''
)
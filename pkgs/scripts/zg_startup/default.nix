{ pkgs, lib, ...}:

pkgs.writeScript "zg_startup" (
  ''
    #!/usr/bin/env bash

    export SHOULD_BUILD=0

    script="${"$"}{0##*/}"
    while test $# -gt 0; do
    case "$1" in
      -h|--help)
        echo "$script - Build the entire Zillow project ecosystem"
        echo " "
        echo "$script [options]"
        echo " "
        echo "options:"
        echo "-h, --help       show brief help"
        echo "--build-shells   build all applicable Nix shells"
        exit 0
        ;;
      --build-shells*)
        export SHOULD_BUILD=1
        shift
        ;;
      *)
        break
        ;;
      esac
    done

    # Remove listing of current zillow git repos
    if [ -e ${builtins.getEnv "HOME"}/.local/share/zillowgits ]; then
      rm ${builtins.getEnv "HOME"}/.local/share/zillowgits
    fi
  ''
  + ( import ./buildProjectList.nix {
    inherit lib;
    inherit pkgs;
    projectList = import ../../../workProjectList;
  } )
)